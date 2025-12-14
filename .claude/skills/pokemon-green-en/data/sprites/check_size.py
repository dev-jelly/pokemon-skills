import urllib.request
from PIL import Image
from io import BytesIO

url = "https://raw.githubusercontent.com/pret/pokered/master/gfx/sprites/youngster.png"
with urllib.request.urlopen(url) as response:
    image_data = response.read()
    image = Image.open(BytesIO(image_data))
    print(f"Size: {image.size}")
    print(f"Mode: {image.mode}")
