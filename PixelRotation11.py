import dxcam
from PIL import Image

dx_camera = dxcam.create(device_idx=0, output_idx=0, output_color="RGB")

region = (0, 0, 32, 32)

dx_camera.start(region=region, video_mode=True, target_fps=120)

while True:
    frame = dx_camera.get_latest_frame()
    img = Image.fromarray(frame)
    pixel_color = img.getpixel((16, 16))
    print(pixel_color)
