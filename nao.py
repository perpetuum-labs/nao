from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler
import json, urlparse
from naoqi import ALProxy

class RequestHandler(BaseHTTPRequestHandler):
    def StiffnessOn(proxy):
        pNames = "Body"
        pStiffnessLists = 1.0
        pTimeLists = 1.0
        proxy.stiffnessInterpolation(pNames, pStiffnessLists, pTimeLists)

    def do_GET(s):
        s.send_response(200)
        s.end_headers()

        IPADDRESS = '127.0.0.1'
        PORT = 9559

        parsed = urlparse.urlparse(s.path)
        cmd = urlparse.parse_qs(parsed.query)
        print(cmd)

        if 'moveTo' in cmd:
            try:
                navProxy = ALProxy('ALMotion', IPADDRESS, PORT)
            except Exception, e:
                self.wfile.write("error")
                print "Could not create proxy to ALNavigation"
                print "Error was: ", e
                return
            x = float(cmd['x'][0])
            y = float(cmd['y'][0])
            t = float(cmd['t'][0])
            navProxy.moveInit()
            navProxy.post.moveTo(x, y, t)

        if 'posture' in cmd:
            try:
                motionProxy = ALProxy("ALMotion", IPADDRESS, PORT)
            except Exception, e:
                print "Could not create proxy to ALMotion"
                print "Error was: ", e

            try:
                postureProxy = ALProxy('ALRobotPosture', IPADDRESS, PORT)
            except Exception, e:
                s.wfile.write("error")
                print "Error was: ", e
                return
            speed = float(cmd['speed'][0])
            postureProxy.goToPosture(cmd['posture'][0], speed)

        if 'text' in cmd:
            try:
                ttsProxy = ALProxy('ALTextToSpeech', IPADDRESS, PORT)
            except Exception, e:
                s.wfile.write("error")
                print "Error was: ", e
                return
            ttsProxy.say(cmd['text'][0])

        s.wfile.write(json.dumps({'code': 0}))

class MyClass(GeneratedClass):
    def __init__(self):
        GeneratedClass.__init__(self)
        HTTPServer(("0.0.0.0", 7654), RequestHandler).serve_forever();

    def onLoad(self):
        #put initialization code here

        pass

    def onUnload(self):
        #put clean-up code here
        pass

    def onInput_onStart(self):
        #self.onStopped() #activate the output of the box
        pass

    def onInput_onStop(self):
        self.onUnload() #it is recommended to reuse the clean-up as the box is stopped
        self.onStopped() #activate the output of the box
