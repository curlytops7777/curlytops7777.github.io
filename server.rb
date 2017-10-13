require 'socket'
require 'uri'
require 'json'

#Dynamically create the NCCO to send synthsized speech to a virtual number

# Initialize a TCPServer
def generate_ncco(request_line)
#Parse the parameters and check if the message was delivered
  params = URI::decode_www_form(request_line).to_h

  #Retrieve with the parameters in this request
  to = params['to']         #The endpoint being called
  from = params['from']     #The endpoint you are calling from
  uuid = params['conversation_uuid']    #The unique ID for this Conversation
  #For more advanced Conversations you use the paramaters to personalize the NCCO

  #Dynamically create the NCCO to run a conversation from your virtual number
  if to == "13479629662"
    ncco=[
      {
        "action": "talk",
        "text": "Hello, this is Transfast. You are listening to a text-to-speech Call made with Nexmo"
      }
    ]
  else
    ncco=[
      {
        "action": "talk",
        "text": "Hello, this is Transfast. You are listening to a text-to-speech Call made with Nexmo"
      }
    ]
  end

  return ncco.to_json
end

server = TCPServer.new('', 80)
# Wait for connections
loop do
  # Wait until a client connects
  socket = server.accept
  method, path = socket.gets.split
  resp = generate_ncco(path)
  # Return the 200 OK

  headers = ["HTTP/1.1 200 OK",
             "Content-Type: application/json",
             "Content-Length: #{resp.length}\r\n\r\n"].join("\r\n")
  socket.puts headers
  #Return the NCCO
  socket.puts resp
  # Close the socket, terminating the connection
  socket.close
end