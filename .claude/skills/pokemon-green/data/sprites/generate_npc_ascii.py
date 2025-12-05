import json
import urllib.request
from PIL import Image
from io import BytesIO
import json
import os
import time

# ASCII characters from dark to light
ASCII_CHARS = [" ", ".", ":", "-", "=", "+", "*", "#", "%", "@"]

def crop_to_content(image):
    bbox = image.getbbox()
    if bbox:
        return image.crop(bbox)
    return image

def grayify(image):
    return image.convert("L")

def convert_image_to_ascii(url, width=28):
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as response:
            image_data = response.read()
    except Exception as e:
        print(f"Failed to download {url}: {e}")
        return None

    try:
        image = Image.open(BytesIO(image_data))
    except Exception as e:
        print(f"Failed to open image {url}: {e}")
        return None

    # Determine frame layout based on height
    w, h = image.size
    
    # Helper to process a crop
    def process_crop(crop_img):
        if crop_img.mode != 'RGBA':
            crop_img = crop_img.convert('RGBA')
        
        # Crop transparent borders
        bbox = crop_img.getbbox()
        if bbox:
            crop_img = crop_img.crop(bbox)
        
        # Resize
        if crop_img.width == 0 or crop_img.height == 0: return []
        aspect_ratio = crop_img.height / crop_img.width
        new_height = int(width * aspect_ratio * 0.55)
        if new_height < 1: new_height = 1
        resized_img = crop_img.resize((width, new_height), Image.NEAREST)
        
        # Grayscale
        grayscale_img = grayify(resized_img)
        
        # ASCII
        pixels = grayscale_img.getdata()
        ascii_str = "".join([ASCII_CHARS[pixel // 26] for pixel in pixels])
        return [ascii_str[i:i+width] for i in range(0, len(ascii_str), width)]

    # Frame extraction logic
    # Standard width is 16.
    # Height 16: Static (1 frame)
    # Height 48: 3 frames (Down, Up, Left)
    # Height 96: 6 frames (Down, DownWalk, Up, UpWalk, Left, LeftWalk)
    
    frame_height = 16
    num_frames = h // frame_height
    
    raw_frames = []
    for i in range(num_frames):
        crop = image.crop((0, i * frame_height, w, (i + 1) * frame_height))
        raw_frames.append(crop)
        
    if num_frames == 1:
        # Static
        ascii_art = process_crop(raw_frames[0])
        frames = {
            "down": ascii_art, "up": ascii_art, "left": ascii_art, "right": ascii_art,
            "down_walk": ascii_art, "up_walk": ascii_art, "left_walk": ascii_art, "right_walk": ascii_art
        }
    elif num_frames == 3:
        # Down, Up, Left
        down = process_crop(raw_frames[0])
        up = process_crop(raw_frames[1])
        left = process_crop(raw_frames[2])
        right = process_crop(raw_frames[2].transpose(Image.FLIP_LEFT_RIGHT))
        
        frames = {
            "down": down, "up": up, "left": left, "right": right,
            "down_walk": down, "up_walk": up, "left_walk": left, "right_walk": right # Fallback
        }
    elif num_frames == 6:
        # Down, DownWalk, Up, UpWalk, Left, LeftWalk
        down = process_crop(raw_frames[0])
        down_walk = process_crop(raw_frames[1])
        up = process_crop(raw_frames[2])
        up_walk = process_crop(raw_frames[3])
        left = process_crop(raw_frames[4])
        left_walk = process_crop(raw_frames[5])
        
        right = process_crop(raw_frames[4].transpose(Image.FLIP_LEFT_RIGHT))
        right_walk = process_crop(raw_frames[5].transpose(Image.FLIP_LEFT_RIGHT))
        
        frames = {
            "down": down, "down_walk": down_walk,
            "up": up, "up_walk": up_walk,
            "left": left, "left_walk": left_walk,
            "right": right, "right_walk": right_walk
        }
    else:
        # Unknown format, just take first frame
        ascii_art = process_crop(raw_frames[0])
        frames = {"default": ascii_art, "down": ascii_art}

    return frames

def main():
    # Mapping based on user list and pret/pokered filenames
    # Keys are from user list (English), Values are filenames in pret/pokered/gfx/sprites/
    npc_map = {
        # Trainer Classes
        "Youngster": "youngster.png",
        "Lass": "brunette_girl.png", # Closest match
        "Bug Catcher": "youngster.png", # Uses youngster sprite
        "Jr. Trainer ♂": "youngster.png", # Uses youngster sprite
        "Jr. Trainer ♀": "brunette_girl.png", # Uses lass sprite
        "Hiker": "hiker.png",
        "Biker": "biker.png",
        "Fisherman": "fisher.png", # Note: fisher.png, not fisherman.png
        "Swimmer ♂": "swimmer.png",
        "Swimmer ♀": "brunette_girl.png", # Uses lass sprite
        "Sailor": "sailor.png",
        "Picnicker": "brunette_girl.png", # Uses lass sprite
        "Camper": "youngster.png", # Uses youngster sprite
        "Super Nerd": "super_nerd.png",
        "Rocker": "rocker.png",
        "Juggler": "super_nerd.png", # Uses super nerd sprite
        "Tamer": "cooltrainer_m.png", # Uses cooltrainer m sprite
        "Bird Keeper": "cooltrainer_m.png", # Uses cooltrainer m sprite
        "Blackbelt": "hiker.png", # Uses hiker sprite (or cooltrainer)
        "Channeler": "channeler.png",
        "Gambler": "gambler.png",
        "Engineer": "scientist.png", # Uses scientist sprite
        "Cue Ball": "biker.png", # Uses biker sprite
        "Psychic": "channeler.png", # Uses channeler sprite
        "Burglar": "super_nerd.png", # Uses super nerd sprite
        "Cooltrainer ♂": "cooltrainer_m.png",
        "Cooltrainer ♀": "cooltrainer_f.png",
        "Gentleman": "gentleman.png",
        "Beauty": "beauty.png",
        "Scientist": "scientist.png",
        "Pokemaniac": "super_nerd.png",
        "Rocket Grunt": "rocket.png",

        # Gym Leaders
        "Brock": "brock.png", # Actually uses super_nerd in Gen 1? No, has unique sprite in some versions, but often generic. Let's check if brock.png exists. It doesn't in the list!
        # Re-checking list for Gym Leaders...
        # koga.png exists.
        # lance.png exists.
        # lorelei.png exists.
        # bruno.png exists.
        # agatha.png exists.
        # giovanni.png exists.
        # misty.png? No.
        # brock.png? No.
        # erika.png? No.
        # lt_surge.png? No.
        # sabrina.png? No.
        # blaine.png? No.
        # In Gen 1, many gym leaders used generic sprites.
        # Brock -> Super Nerd
        # Misty -> Beauty / Brunette Girl
        # Lt. Surge -> Rocker / Gentleman
        # Erika -> Beauty
        # Sabrina -> Girl / Brunette Girl
        # Blaine -> Scientist / Balding Guy
        
        "Brock": "super_nerd.png",
        "Misty": "brunette_girl.png",
        "Lt. Surge": "rocker.png",
        "Erika": "beauty.png",
        "Koga": "koga.png", # Exists!
        "Sabrina": "brunette_girl.png",
        "Blaine": "scientist.png",
        "Giovanni": "giovanni.png",

        # Elite Four & Champion
        "Lorelei": "lorelei.png",
        "Bruno": "bruno.png",
        "Agatha": "agatha.png",
        "Lance": "lance.png",
        "Champion (Rival)": "blue.png",

        # Story NPCs
        "Professor Oak": "oak.png",
        "Rival": "blue.png",
        "Rival Sister (Daisy)": "daisy.png",
        "Mom": "mom.png",
        "Bill": "super_nerd.png", # Uses super nerd
        "Mr. Fuji": "mr_fuji.png",
        "Rocket Boss Giovanni": "giovanni.png",
        "Captain": "captain.png",
        "Old Man": "gramps.png",
        "Ghost": "channeler.png",
        "Copycat": "brunette_girl.png",
        "Name Rater": "gentleman.png",
        "Safari Warden": "warden.png",
        "Silph President": "silph_president.png",
        "Silph Worker": "silph_worker_m.png",

        # Facility NPCs
        "Nurse Joy": "nurse.png",
        "Clerk": "clerk.png",
        "PC Manager": "middle_aged_man.png",
        "Daycare Man": "gramps.png",
        "Fishing Guru": "fishing_guru.png",
        "Trade NPC": "middle_aged_man.png",

        # Misc NPCs
        "Boy": "youngster.png",
        "Girl": "girl.png",
        "Man": "middle_aged_man.png",
        "Woman": "middle_aged_woman.png",
        "Old Woman": "granny.png",
        "Fat Man": "balding_guy.png",
        "Little Boy": "little_boy.png",
        "Little Girl": "little_girl.png",
        "Waiter": "waiter.png",
        "Cook": "cook.png",
        "Balding Guy": "balding_guy.png",
        
        # Extra mappings for specific IDs in trading.json
        "Trade NPC": "middle_aged_man.png",
        "Youngster": "youngster.png",
        "Fisherman": "fisher.png",
        "Biker": "biker.png",
        "Gentleman": "gentleman.png",
        "Beauty": "beauty.png",
        "Scientist": "scientist.png",
        
        # Korean name mappings
        "교환 아저씨": "middle_aged_man.png",
        "꼬마": "youngster.png",
        "낚시꾼": "fisher.png",
        "폭주족": "biker.png",
        "신사": "gentleman.png",
        "아가씨": "beauty.png",
        "연구원": "scientist.png",
        "오박사": "oak.png",
        "경쟁자 누나": "daisy.png",
        "SS앤호 선장": "captain.png",
        "로켓단 보스": "giovanni.png",
        "실프주식회사 사장": "silph_president.png",
        "실프주식회사 직원": "silph_worker_m.png",
        "후지 노인": "mr_fuji.png",
        "사파리존 관장": "warden.png",
        "간호순": "nurse.png",
        "상점 직원": "clerk.png"
    }

    # Base URL for pret/pokered sprites
    BASE_URL = "https://raw.githubusercontent.com/pret/pokered/master/gfx/sprites/"

    # Create output directory
    output_dir = "data/sprites/npc_ascii" # Updated output directory
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    print(f"Generating ASCII art for {len(npc_map)} NPCs...")

    # Placeholder for sprite_files, as it was not defined in the original context.
    # Assuming sprite_files would be a list of dicts, each with 'name' and 'download_url'.
    # For this change, we will revert to using BASE_URL + filename directly,
    # as `sprite_files` was not provided and would cause an error.
    # If `sprite_files` is meant to be loaded from somewhere, that code needs to be added.

    for npc_name, filename in npc_map.items():
        # Reverting to direct URL construction as `sprite_files` was not defined.
        url = BASE_URL + filename
            
        print(f"Processing {npc_name} ({filename})...", end="", flush=True)
        
        frames = convert_image_to_ascii(url) # Use the constructed URL
        
        if frames:
            # Save to individual JSON file
            # Sanitize filename
            safe_name = npc_name.replace(" ", "_").replace(".", "").replace("♂", "_m").replace("♀", "_f")
            output_path = os.path.join(output_dir, f"{safe_name}.json")
            
            with open(output_path, "w", encoding="utf-8") as f:
                json.dump(frames, f, ensure_ascii=False, indent=2)
            print("Done!")
        else:
            print("Failed!")

    print(f"All done! Saved to {output_dir}/")

if __name__ == "__main__":
    main()
