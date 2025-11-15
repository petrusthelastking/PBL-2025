import gradio as gr
import torch
import cv2
import numpy as np
from PIL import Image
import sys
import os

# Add lib directory to path
sys.path.append(os.path.join(os.path.dirname(__file__), "lib"))

from lib.model_v2 import ModelMLPV2
from lib.extract_features import extract_all_features
from lib.segment import auto_segment


# Konfigurasi
MODEL_PATH = os.path.join(
    os.path.dirname(__file__),
    "notebook",
    "models",
    "claude_dropout-0.3",
    "best_model.pth",
)
CLASS_NAMES = ["Sayur Akar", "Sayur Buah", "Sayur Daun", "Sayur Polong"]
DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Load model
print("Loading model...")
model = ModelMLPV2(num_classes=len(CLASS_NAMES), dropout_rate=0.1)
checkpoint = torch.load(MODEL_PATH, map_location=DEVICE)

# Handle different checkpoint formats
if isinstance(checkpoint, dict) and "model_state_dict" in checkpoint:
    model.load_state_dict(checkpoint["model_state_dict"])
else:
    model.load_state_dict(checkpoint)

model = model.to(DEVICE)
model.eval()
print(f"Model loaded successfully on {DEVICE}")


def predict_image(
    image,
    use_segmentation=True,
    seg_method="hsv",
    use_custom_params=False,
    # HSV parameters
    hsv_h_lower=20,
    hsv_s_lower=40,
    hsv_v_lower=40,
    hsv_h_upper=180,
    hsv_s_upper=255,
    hsv_v_upper=255,
    # GrabCut parameters
    grabcut_iterations=5,
    # Adaptive threshold parameters
    adaptive_kernel_size=5,
):
    """
    Prediksi gambar sayuran

    Args:
        image: PIL Image atau numpy array
        use_segmentation: Apakah menggunakan segmentasi
        seg_method: Metode segmentasi ('hsv', 'grabcut', 'adaptive', 'none')
        hsv_h_lower, hsv_s_lower, hsv_v_lower: Lower bounds untuk HSV
        hsv_h_upper, hsv_s_upper, hsv_v_upper: Upper bounds untuk HSV
        grabcut_iterations: Jumlah iterasi untuk GrabCut
        adaptive_kernel_size: Ukuran kernel untuk adaptive threshold

    Returns:
        Tuple (label, confidences_dict, segmented_image)
    """
    try:
        # Convert PIL Image to numpy array (BGR for OpenCV)
        if isinstance(image, Image.Image):
            image_np = np.array(image)
            # Convert RGB to BGR
            image_bgr = cv2.cvtColor(image_np, cv2.COLOR_RGB2BGR)
            image_bgr = cv2.resize(image_bgr, (224, 224))
        else:
            image_bgr = image

        # Apply segmentation if enabled
        if use_segmentation and seg_method != "none":
            if seg_method == "hsv":
                from lib.segment import segment_hsv_color

                segmented_img = segment_hsv_color(
                    image_bgr.copy(),
                    lower_bound=(
                        (hsv_h_lower, hsv_s_lower, hsv_v_lower)
                        if use_custom_params
                        else (20, 40, 40)
                    ),
                    upper_bound=(
                        (hsv_h_upper, hsv_s_upper, hsv_v_upper)
                        if use_custom_params
                        else (180, 255, 255)
                    ),
                )
            elif seg_method == "grabcut":
                from lib.segment import segment_grabcut

                segmented_img = segment_grabcut(
                    image_bgr.copy(),
                    iterations=grabcut_iterations if use_custom_params else 5,
                )
            elif seg_method == "adaptive":
                from lib.segment import segment_adaptive_threshold

                segmented_img = segment_adaptive_threshold(
                    image_bgr.copy(),
                    kernel_size=adaptive_kernel_size if use_custom_params else 5,
                )
            else:
                segmented_img = auto_segment(image_bgr.copy(), method=seg_method)
        else:
            segmented_img = image_bgr.copy()

        # Extract features (44 features total)
        features = extract_all_features(
            segmented_img,
            use_segmentation=False,  # Already segmented above
            seg_method="none",
        )

        # Convert to tensor
        features_tensor = torch.tensor(features, dtype=torch.float32).unsqueeze(0)
        features_tensor = features_tensor.to(DEVICE)

        # Predict
        with torch.no_grad():
            outputs = model(features_tensor)
            probabilities = torch.softmax(outputs, dim=1)
            confidence, predicted = torch.max(probabilities, 1)

            # Get all class probabilities
            probs = probabilities[0].cpu().numpy()

        # Prepare results
        predicted_class = CLASS_NAMES[predicted.item()]
        confidence_value = confidence.item()

        # Create confidence dictionary for all classes
        confidences = {CLASS_NAMES[i]: float(probs[i]) for i in range(len(CLASS_NAMES))}

        # Convert segmented image back to RGB for display
        segmented_rgb = cv2.cvtColor(segmented_img, cv2.COLOR_BGR2RGB)

        return predicted_class, confidences, segmented_rgb

    except Exception as e:
        print(f"Error during prediction: {e}")
        import traceback

        traceback.print_exc()
        return f"Error: {str(e)}", {}, None


def gradio_predict(
    image,
    use_segmentation,
    seg_method,
    use_custom_params,
    hsv_h_lower,
    hsv_s_lower,
    hsv_v_lower,
    hsv_h_upper,
    hsv_s_upper,
    hsv_v_upper,
    grabcut_iterations,
    adaptive_kernel_size,
):
    """
    Wrapper function untuk Gradio interface
    """
    predicted_class, confidences, segmented_img = predict_image(
        image,
        use_segmentation,
        seg_method,
        use_custom_params,
        hsv_h_lower,
        hsv_s_lower,
        hsv_v_lower,
        hsv_h_upper,
        hsv_s_upper,
        hsv_v_upper,
        grabcut_iterations,
        adaptive_kernel_size,
    )

    # Format output
    result_text = f"**Prediksi:** {predicted_class}\n\n**Confidence:** {confidences.get(predicted_class, 0):.2%}"

    return result_text, confidences, segmented_img


# Create Gradio interface
with gr.Blocks(title="Klasifikasi Sayuran") as demo:
    gr.Markdown(
        """
        # 🥬 Sistem Klasifikasi Sayuran
        
        Upload gambar sayuran untuk mengklasifikasikannya ke dalam 4 kategori:
        - **Sayur Akar** (wortel, lobak, dll)
        - **Sayur Buah** (tomat, terong, cabai, dll)
        - **Sayur Daun** (bayam, sawi, kangkung, dll)
        - **Sayur Polong** (kacang panjang, buncis, dll)
        
        Model menggunakan MLP dengan ekstraksi fitur: 44 (HOG: 5, LBP: 6, SIFT: 8, Color-Histogram: 12, Haralick: 13).
        """
    )

    with gr.Row():
        with gr.Column():
            input_image = gr.Image(type="pil", label="Upload Gambar Sayuran")

            with gr.Accordion("Pengaturan Segmentasi", open=False):
                use_seg = gr.Checkbox(
                    value=True,
                    label="Gunakan Segmentasi",
                    info="Memisahkan objek dari background",
                )
                seg_method = gr.Radio(
                    choices=["hsv", "grabcut", "adaptive", "u2netp", "none"],
                    value="hsv",
                    label="Metode Segmentasi",
                    info="HSV: berdasarkan warna, GrabCut: berbasis grafik, Adaptive: threshold adaptif, U2Net-P: deep learning",
                )

                use_custom_params = gr.Checkbox(
                    value=False,
                    label="Gunakan Parameter Custom",
                    info="Centang untuk mengatur parameter secara manual",
                )

                # HSV Parameters
                with gr.Group(visible=True) as hsv_params:
                    gr.Markdown("**Parameter HSV**")
                    with gr.Row():
                        hsv_h_lower = gr.Slider(
                            minimum=0,
                            maximum=179,
                            value=20,
                            step=1,
                            label="Hue Lower",
                            info="Batas bawah Hue (0-179)",
                            interactive=False,
                        )
                        hsv_h_upper = gr.Slider(
                            minimum=0,
                            maximum=179,
                            value=179,
                            step=1,
                            label="Hue Upper",
                            info="Batas atas Hue (0-179)",
                            interactive=False,
                        )
                    with gr.Row():
                        hsv_s_lower = gr.Slider(
                            minimum=0,
                            maximum=255,
                            value=40,
                            step=1,
                            label="Saturation Lower",
                            info="Batas bawah Saturasi (0-255)",
                            interactive=False,
                        )
                        hsv_s_upper = gr.Slider(
                            minimum=0,
                            maximum=255,
                            value=255,
                            step=1,
                            label="Saturation Upper",
                            info="Batas atas Saturasi (0-255)",
                            interactive=False,
                        )
                    with gr.Row():
                        hsv_v_lower = gr.Slider(
                            minimum=0,
                            maximum=255,
                            value=40,
                            step=1,
                            label="Value Lower",
                            info="Batas bawah Value (0-255)",
                            interactive=False,
                        )
                        hsv_v_upper = gr.Slider(
                            minimum=0,
                            maximum=255,
                            value=255,
                            step=1,
                            label="Value Upper",
                            info="Batas atas Value (0-255)",
                            interactive=False,
                        )

                # GrabCut Parameters
                with gr.Group(visible=False) as grabcut_params:
                    gr.Markdown("**Parameter GrabCut**")
                    grabcut_iterations = gr.Slider(
                        minimum=1,
                        maximum=10,
                        value=5,
                        step=1,
                        label="Iterasi",
                        info="Jumlah iterasi GrabCut (1-10)",
                        interactive=False,
                    )

                # Adaptive Threshold Parameters
                with gr.Group(visible=False) as adaptive_params:
                    gr.Markdown("**Parameter Adaptive Threshold**")
                    adaptive_kernel_size = gr.Slider(
                        minimum=3,
                        maximum=15,
                        value=5,
                        step=2,
                        label="Kernel Size",
                        info="Ukuran kernel morfologi (ganjil)",
                        interactive=False,
                    )

                # Update parameter visibility based on selected method
                def update_params_visibility(method):
                    return {
                        hsv_params: gr.update(visible=(method == "hsv")),
                        grabcut_params: gr.update(visible=(method == "grabcut")),
                        adaptive_params: gr.update(visible=(method == "adaptive")),
                    }

                # Update slider interactivity based on custom params checkbox
                def update_sliders_interactivity(use_custom):
                    return [
                        gr.update(interactive=use_custom),  # hsv_h_lower
                        gr.update(interactive=use_custom),  # hsv_h_upper
                        gr.update(interactive=use_custom),  # hsv_s_lower
                        gr.update(interactive=use_custom),  # hsv_s_upper
                        gr.update(interactive=use_custom),  # hsv_v_lower
                        gr.update(interactive=use_custom),  # hsv_v_upper
                        gr.update(interactive=use_custom),  # grabcut_iterations
                        gr.update(interactive=use_custom),  # adaptive_kernel_size
                    ]

                seg_method.change(
                    fn=update_params_visibility,
                    inputs=[seg_method],
                    outputs=[hsv_params, grabcut_params, adaptive_params],
                )

                use_custom_params.change(
                    fn=update_sliders_interactivity,
                    inputs=[use_custom_params],
                    outputs=[
                        hsv_h_lower,
                        hsv_h_upper,
                        hsv_s_lower,
                        hsv_s_upper,
                        hsv_v_lower,
                        hsv_v_upper,
                        grabcut_iterations,
                        adaptive_kernel_size,
                    ],
                )

            predict_btn = gr.Button("🔍 Klasifikasi", variant="primary", size="lg")

        with gr.Column():
            result_text = gr.Markdown(label="Hasil Prediksi")
            confidence_plot = gr.Label(label="Confidence Score", num_top_classes=4)
            segmented_output = gr.Image(label="Gambar Setelah Segmentasi")

    # Example images (will try to load from dataset if available)
    example_images = []
    train_path = "dataset_prepared/train"
    if os.path.exists(train_path):
        for class_name in CLASS_NAMES:
            # Convert class name to folder name
            folder_map = {
                "Sayur Akar": "Sayur_Akar",
                "Sayur Buah": "Sayur_Buah",
                "Sayur Daun": "Sayur_Daun",
                "Sayur Polong": "Sayur_Polong",
            }
            folder_name = folder_map.get(class_name, class_name.replace(" ", "_"))
            class_path = os.path.join(train_path, folder_name)

            if os.path.exists(class_path):
                # Get first image from this class
                images = [
                    f
                    for f in os.listdir(class_path)
                    if f.lower().endswith((".png", ".jpg", ".jpeg"))
                ]
                if images:
                    example_images.append(
                        [os.path.join(class_path, images[0]), True, "hsv"]
                    )

    if example_images:
        gr.Markdown("### 📸 Contoh Gambar")
        gr.Examples(
            examples=example_images,
            inputs=[input_image, use_seg, seg_method],
            label="Klik untuk mencoba",
        )

    # Connect button to function
    predict_btn.click(
        fn=gradio_predict,
        inputs=[
            input_image,
            use_seg,
            seg_method,
            use_custom_params,
            hsv_h_lower,
            hsv_s_lower,
            hsv_v_lower,
            hsv_h_upper,
            hsv_s_upper,
            hsv_v_upper,
            grabcut_iterations,
            adaptive_kernel_size,
        ],
        outputs=[result_text, confidence_plot, segmented_output],
    )


if __name__ == "__main__":
    print("Starting Gradio app...")
    demo.launch(server_name="0.0.0.0", server_port=7879, share=False)
