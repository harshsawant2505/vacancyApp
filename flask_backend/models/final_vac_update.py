#so this file include all the functions to detect a vehicle , the direction in which the object is moving and numberplate tracking to keep track of object, but it is not yet integrated due to less testing

import cv2
import matplotlib.pyplot as plt
import numpy as np
from pymongo import MongoClient
import pytesseract

# Change directory
#os.chdir(r'C:\Users\kedron\Documents\vacancyApp\flask_backend\models')
# Load model
config_file = r'ssd_mobilenet_v3_large_coco_2020_01_14.pbtxt'
frozen_model = r'frozen_inference_graph.pb'
model = cv2.dnn_DetectionModel(frozen_model, config_file)
model.setInputSize(360, 360)
model.setInputScale(1.0 / 127.5)
model.setInputMean((127.5, 127.5, 127.5))
model.setInputSwapRB(True)

# Connect to MongoDB
client = MongoClient() #('mongodb+srv://hsmedia2505:ERJzEdAOGkZ80vPD@cluster0.8tdaz.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0')
db = client['test']
print(db)
collection = db['datasets']
print(collection)
# Updating in database
def increment_vehicle_counter(entry_cam, vehicle_type, vehicle_type_occ):
    query = {'entry_cam': entry_cam}
    document = collection.find_one(query)
    if document:
        v = document.get(vehicle_type)
        v_occ = document.get(vehicle_type_occ)
        if v != 0 and v_occ < v:
            print("v++")
            update = {'$inc': {vehicle_type_occ: 1}}
            collection.update_one({'_id': document['_id']}, update)

def decrement_vehicle_counter(entry_cam, vehicle_type, vehicle_type_occ):
    query = {'entry_cam': entry_cam}
    document = collection.find_one(query)
    
    if document:
        v = document.get(vehicle_type)
        v_occ = document.get(vehicle_type_occ)
        if v != 0 and v_occ > 0:
            print("v--")
            update = {'$inc': {vehicle_type_occ: -1}}
            collection.update_one({'_id': document['_id']}, update)

objects_observable = [2, 3, 4]
pass_line = 170

def getCenter(x, y, w, h):
    x1 = int(w / 2)
    y1 = int(h / 2)
    cx = x + x1
    cy = y + y1
    return cx, cy

# Dictionary to store the previous positions of detected vehicles
previous_positions = {}
vehicle_states = {}

def detect_number_plate(image_path):
    # Read the image
    image = cv2.imread(image_path)
    
    # Convert to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
    # Apply some preprocessing
    gray = cv2.bilateralFilter(gray, 11, 17, 17)
    edged = cv2.Canny(gray, 30, 200)
    
    # Find contours
    contours, _ = cv2.findContours(edged.copy(), cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    contours = sorted(contours, key=cv2.contourArea, reverse=True)[:10]
    
    number_plate_contour = None
    for contour in contours:
        # Approximate the contour
        peri = cv2.arcLength(contour, True)
        approx = cv2.approxPolyDP(contour, 0.018 * peri, True)
        
        # If the contour has 4 vertices, it might be the number plate
        if len(approx) == 4:
            number_plate_contour = approx
            break
    
    if number_plate_contour is None:
        print("No number plate detected")
        return 
    
    # Mask the part other than the number plate
    mask = cv2.drawContours(image.copy(), [number_plate_contour], -1, (0, 255, 0), 3)
    cv2.imshow("Number Plate Detected", mask)
    cv2.waitKey(0)
    
    # Crop the number plate from the image
    x, y, w, h = cv2.boundingRect(number_plate_contour)
    cropped = gray[y:y+h, x:x+w]
    
    # Use Tesseract to extract text
    text = pytesseract.image_to_string(cropped, config='--psm 8')
    return text.strip()



def resize_with_padding(image, target_size=300):
    # Getting the original image dimensions
    h, w, _ = image.shape
    aspect_ratio = w / h
    
    # Determining the new dimensions while maintaining the aspect ratio
    if aspect_ratio > 1:
        # Wider than tall
        new_w = target_size
        new_h = int(target_size / aspect_ratio)
    else:
        # Taller than wide
        new_h = target_size
        new_w = int(target_size * aspect_ratio)
    
    # Resizing the image to fit within the target size
    resized_image = cv2.resize(image, (new_w, new_h))
    
    # Calculate padding to make the image square (300x300)
    delta_w = target_size - new_w
    delta_h = target_size - new_h
    top, bottom = delta_h // 2, delta_h - (delta_h // 2)
    left, right = delta_w // 2, delta_w - (delta_w // 2)
    
    # Adding padding
    color = [0, 0, 0]
    padded_image = cv2.copyMakeBorder(resized_image, top, bottom, left, right, cv2.BORDER_CONSTANT, value=color)
    
    return padded_image
    
def check_for_vehicles(frame, cam_id):
    vehicle_id = detect_number_plate(frame)
    frame = resize_with_padding(frame)
    ClassIndex, confidence, bbox = model.detect(frame, confThreshold=0.55)
    
    # Draw the pass line on the frame
    frame_height = frame.shape[0]
    cv2.line(frame, (pass_line, 0), (pass_line, frame_height), (0, 255, 0), 2)
    
    if len(ClassIndex) != 0:
        for ClassInd, conf, boxes in zip(ClassIndex.flatten(), confidence.flatten(), bbox):            
            if ClassInd in objects_observable:
                if ClassInd in [2, 3, 4]:
                    x, y, w, h = boxes
                    cx, cy = getCenter(x, y, w, h)
                    cv2.circle(frame, (cx, cy), 5, (0, 0, 255), -1)
                    if vehicle_id not in previous_positions:
                        previous_positions[vehicle_id] = (cx, cy)
                        vehicle_states[vehicle_id] = None
                        vehicle_id += 1
                    else:
                        (prev_cx, prev_cy) = previous_positions[vehicle_id]
                        if cx > pass_line and prev_cx <= pass_line:
                            if vehicle_states[vehicle_id] != "out":
                                if ClassInd == 3:
                                    increment_vehicle_counter(cam_id, '4w', '4w_occ')
                                else:
                                    increment_vehicle_counter(cam_id, '2w', '2w_occ')
                                vehicle_states[vehicle_id] = "out"
                        elif cx <= pass_line and prev_cx > pass_line:
                            if vehicle_states[vehicle_id] != "in":
                                if ClassInd == 3:
                                    decrement_vehicle_counter(cam_id, '4w', '4w_occ')
                                else:
                                    decrement_vehicle_counter(cam_id, '2w', '2w_occ')
                                vehicle_states[vehicle_id] = "in"
                        previous_positions[vehicle_id] = (cx, cy)
                    
    return frame

    
rstp = '5057527-uhd_3840_2160_25fps.mp4'
print(rstp)
cap = cv2.VideoCapture(rstp)
ret = True
while ret:
    ret, frame = cap.read()
    if not ret:
        break
    frame = check_for_vehicles(frame, rstp)
    cv2.imshow('Object Detection', frame)
    if (cv2.waitKey(2) & 0xFF) == ord('q'):
        break
cap.release()
cv2.destroyAllWindows()