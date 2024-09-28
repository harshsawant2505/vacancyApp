
from config import app
from flask import request, jsonify

contact = {
    "name": "Jane smith",
    "phone": "939359839539",
    "email": "example@gmail.com"

}

@app.route("/", methods=["GET"])
def home():
    return jsonify({"data": "Data from python  sdgdgerver get route"})


@app.route("/contacts", methods=["GET"])
def contacts():
    return jsonify(contact)

@app.route("/getParkingSpots", methods=["POST"])
def getParkingSpots():
    if request.is_json:
        data = request.get_json()
        city = data.get('city')
        print(city)
        print("Data received:", data)
        response = {
            'received_data': data,
            'status': 'success'
        }
        return jsonify(response)
    else:
        print("Request is not JSON")
        return jsonify({'error': 'Request must be JSON'}), 400


@app.route("/", methods=["POST"])
def set():
   # Check if request contains JSON data
    if request.is_json:
        # Get the JSON data from the request

      
        data = request.get_json()

        print("Number:",data.get('number'),"Key:",data.get('key'),"Boolean:",data.get('boolean'))
        
        
        # Process the data (for demonstration, just echoing it back
        response = {
            'received_data': data,
            'status': 'success'
        }
        return jsonify(response)
    else:
        return jsonify({'error': 'Request must be JSON'}), 400  


if __name__ == "__main__":
    app.run(host = 'localhost', port=8000, debug=True)  