#imported packages
import cv2
import matplotlib.pyplot as plt
import numpy as np
import tensorflow as tf

config_file = "ssd_mobilenet_v3_large_coco_2020_01_14.pbtxt"
frozen_model = "frozen_inference_graph.pb"

model = cv2.dnn_DetectionModel(frozen_model, config_file) 
model.setInputSize(360,360)
model.setInputScale(1.0/127.5)
model.setInputMean((127.5,127.5,127.5))
model.setInputSwapRB(True)


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

objects_observable = [2, 3, 4]
pass_line = 170

def getCenter(x, y, w, h):
    x1 = int(w / 2)
    y1 = int(h / 2)
    cx = x + x1
    cy = y + y1
    return cx, cy

# Dictionary to store the previous positions of detected vehicles
previous_positions = {} #for getting direction
vehicle_states = {} #not to repeat count
vehicle_id = 0

def check_for_vehicles(frame):
    frame = resize_with_padding(frame)
    global vehicle_id
    ClassIndex, confidence, bbox = model.detect(frame, confThreshold=0.55)
    
    # Draw the pass line on the frame
    frame_height = frame.shape[0]
    cv2.line(frame, (pass_line, 0), (pass_line, frame_height), (0, 255, 0), 2)
    
    if len(ClassIndex) != 0:
        for ClassInd, conf, boxes in zip(ClassIndex.flatten(), confidence.flatten(), bbox):
            if ClassInd in objects_observable:
                if ClassInd == 3:
                    x, y, w, h = boxes
                    cx, cy = getCenter(x, y, w, h)
                
                    # Assign a unique ID to each new vehicle
                    if vehicle_id not in previous_positions:
                        previous_positions[vehicle_id] = (cx, cy)
                        vehicle_states[vehicle_id] = None
                        vehicle_id += 1
                
                    # Check if the vehicle was previously detected
                    for vid, (prev_cx, prev_cy) in previous_positions.items():
                        # Determine direction
                        if cx > pass_line and prev_cx <= pass_line:
                            if vehicle_states[vid] != "out":
                                fn #harsh PUT request here to decrement 4w for this loc
                                vehicle_states[vid] = "out"
                        elif cx <= pass_line and prev_cx > pass_line:
                            if vehicle_states[vid] != "in":
                                fn #harsh PUT request here to increment 4w for this loc
                                vehicle_states[vid] = "in"
                
                    # Update the previous position
                    previous_positions[vehicle_id - 1] = (cx, cy)
                    
                elif ClassInd in [2, 4]:
                    x, y, w, h = boxes
                    cx, cy = getCenter(x, y, w, h)
                
                    # Assign a unique ID to each new vehicle
                    if vehicle_id not in previous_positions:
                        previous_positions[vehicle_id] = (cx, cy)
                        vehicle_states[vehicle_id] = None
                        vehicle_id += 1
                
                    # Check if the vehicle was previously detected
                    for vid, (prev_cx, prev_cy) in previous_positions.items():
                        # Determine direction
                        if cx > pass_line and prev_cx <= pass_line:
                            if vehicle_states[vid] != "out":
                                fn #harsh PUT request here to decrement 2w for this loc
                                vehicle_states[vid] = "out"
                        elif cx <= pass_line and prev_cx > pass_line:
                            if vehicle_states[vid] != "in":
                                fn #harsh PUT request here to increment 2w for this loc
                                vehicle_states[vid] = "in"
                
                    # Update the previous position
                    previous_positions[vehicle_id - 1] = (cx, cy)
    
    return frame

#for demonstration purpose
rtsp = "vid.mp4"
cap = cv2.VideoCapture(rtsp)
ret = True
while ret:
  ret, frame = cap.read()
  if not ret:
    break
  frame = check_for_vehicles(frame)
  cv2.imshow('Object Detection', frame) 
  if(cv2.waitKey(2) & 0xFF) == ord('q'):
        break   
cap.release()
cv2.destroyAllWindows()     