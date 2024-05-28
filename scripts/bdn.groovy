import hudson.model.*

def thr = Thread.currentThread()
def build = thr?.executable


def parameters = build?.actions.find{ it instanceof ParametersAction }?.parameters
parameters.each {
   println "parameter ${it.name}:"
   println it.dump()
   println "-" * 80
}

System.getenv("BUILD_DISPLAY_NAME")
System.getProperty('BUILD_DISPLAY_NAME')
System.getProperty('BUILD_URL')
System.getProperty('BUILD_ID')
System.getProperty('BUILD_TAG')
System.getProperty('BUILD_NUMBER')
System.getProperty('BUILD_NUMBER')
