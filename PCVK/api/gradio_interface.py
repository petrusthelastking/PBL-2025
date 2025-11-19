"""
Gradio web interface for vegetable classification
"""

import os
import gradio as gr
import cv2
import numpy as np
from PIL import Image

from api.config import CLASS_NAMES
from api.model_loader import model_manager
from api.inference import predict_image


def gradio_predict(
    image,
    use_segmentation,
    seg_method,
    model_type,
    use_custom_params,
    hsv_h_lower,
    hsv_s_lower,
    hsv_v_lower,
    hsv_h_upper,
    hsv_s_upper,
    hsv_v_upper,
    grabcut_iterations,
    adaptive_kernel_size,
    apply_brightness_contrast,
):
    """
    Wrapper function for Gradio interface
    """
    try:
        # Check if model is loaded
        if not model_manager.is_loaded(model_type):
            return f"Error: Model '{model_type}' is not loaded", {}, None
        
        # Get model
        model = model_manager.get_model(model_type)
        
        # Convert PIL Image to numpy array (BGR for OpenCV)
        if isinstance(image, Image.Image):
            image_np = np.array(image)
            image_bgr = cv2.cvtColor(image_np, cv2.COLOR_RGB2BGR)
            image_bgr = cv2.resize(image_bgr, (224, 224))
        else:
            image_bgr = image

        # Apply segmentation if enabled
        if use_segmentation and seg_method != "none":
            if seg_method == "hsv":
                import sys
                sys.path.append(os.path.join(os.path.dirname(__file__), ".."))
                from lib.segment import segment_hsv_color, apply_clahe, apply_automatic_brightness_contrast
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
                if apply_brightness_contrast:
                    segmented_img = apply_clahe(apply_automatic_brightness_contrast(segmented_img))
            elif seg_method == "grabcut":
                import sys
                sys.path.append(os.path.join(os.path.dirname(__file__), ".."))
                from lib.segment import segment_grabcut, apply_clahe, apply_automatic_brightness_contrast
                segmented_img = segment_grabcut(
                    image_bgr.copy(),
                    iterations=grabcut_iterations if use_custom_params else 5,
                )
                if apply_brightness_contrast:
                    segmented_img = apply_clahe(apply_automatic_brightness_contrast(segmented_img))
            elif seg_method == "adaptive":
                import sys
                sys.path.append(os.path.join(os.path.dirname(__file__), ".."))
                from lib.segment import segment_adaptive_threshold, apply_clahe, apply_automatic_brightness_contrast
                segmented_img = segment_adaptive_threshold(
                    image_bgr.copy(),
                    kernel_size=adaptive_kernel_size if use_custom_params else 5,
                )
                if apply_brightness_contrast:
                    segmented_img = apply_clahe(apply_automatic_brightness_contrast(segmented_img))
            else:
                import sys
                sys.path.append(os.path.join(os.path.dirname(__file__), ".."))
                from lib.segment import auto_segment
                segmented_img = auto_segment(image_bgr.copy(), method=seg_method, applyBrightContClahe=apply_brightness_contrast)
        else:
            segmented_img = image_bgr.copy()

        # Convert to PIL Image for prediction
        segmented_pil = Image.fromarray(cv2.cvtColor(segmented_img, cv2.COLOR_BGR2RGB))
        
        # Perform prediction
        predicted_class, confidence_value, all_confidences = predict_image(
            model=model,
            image=segmented_pil,
            use_segmentation=False,  # Already segmented above
            seg_method="none"
        )

        # Format output
        result_text = f"**Prediksi:** {predicted_class}\n\n**Confidence:** {confidence_value:.2%}\n\n**Model:** {model_type.upper()}"

        # Convert segmented image back to RGB for display
        segmented_rgb = cv2.cvtColor(segmented_img, cv2.COLOR_BGR2RGB)

        return result_text, all_confidences, segmented_rgb

    except Exception as e:
        print(f"Error during prediction: {e}")
        import traceback
        traceback.print_exc()
        return f"Error: {str(e)}", {}, None


def create_gradio_interface():
    """
    Create Gradio interface for the web UI
    """
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

                predict_btn = gr.Button("🔍 Klasifikasi", variant="primary", size="lg")
                with gr.Accordion("Pengaturan Model dan Segmentasi", open=True):
                    # Model selection
                    model_type = gr.Radio(
                        choices=["mlp", "mlpv2", "mlpv2_auto-clahe"],
                        value="mlpv2_auto-clahe",
                        label="Pilih Model",
                        info="MLP: Simple model, MLPv2: Advanced with residual connections, MLPv2 Auto-CLAHE: MLPv2 trained with automatic brightness/contrast enhancement"
                    )
                    
                    use_seg = gr.Checkbox(
                        value=True,
                        label="Gunakan Segmentasi",
                        info="Memisahkan objek dari background",
                    )
                    seg_method = gr.Radio(
                        choices=["hsv", "grabcut", "adaptive", "u2netp", "none"],
                        value="u2netp",
                        label="Metode Segmentasi",
                        info="HSV: berdasarkan warna, GrabCut: berbasis grafik, Adaptive: threshold adaptif, U2Net-P: deep learning",
                    )
                    
                    # Brightness & Contrast Enhancement
                    apply_brightness_contrast = gr.Checkbox(
                        value=True,
                        label="Gunakan Brightness & Contrast Enhancement (CLAHE)",
                        info="Menerapkan peningkatan kecerahan dan kontras adaptif",
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

                

            with gr.Column():
                result_text = gr.Markdown(label="Hasil Prediksi")
                confidence_plot = gr.Label(label="Confidence Score", num_top_classes=4)
                segmented_output = gr.Image(label="Gambar Setelah Segmentasi")

        # Connect button to function
        predict_btn.click(
            fn=gradio_predict,
            inputs=[
                input_image,
                use_seg,
                seg_method,
                model_type,
                use_custom_params,
                hsv_h_lower,
                hsv_s_lower,
                hsv_v_lower,
                hsv_h_upper,
                hsv_s_upper,
                hsv_v_upper,
                grabcut_iterations,
                adaptive_kernel_size,
                apply_brightness_contrast,
            ],
            outputs=[result_text, confidence_plot, segmented_output],
        )
        
        gr.Markdown("""
        ---
        ### API Endpoints
        - **API Documentation**: [/docs](/docs)
        - **Health Check**: [/api/health](/api/health)
        - **Available Classes**: [/api/classes](/api/classes)
        - **Models Info**: [/api/models](/api/models)
        """)

    return demo
