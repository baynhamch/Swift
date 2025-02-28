# AVAudioEngine

An object that manages a graph of audio nodes, controls playback, and configures real-time rendering constraints.
iOS 8.0+ | iPadOS 8.0+ |Mac Catalyst 13.1+ |macOS 10.10+ | tvOS 9.0+ |visionOS 1.0+ | watchOS 2.0+

'''Swift
class AVAudioEngine
'''

## Overview
An audio engine object contains a group of AVAudioNode instances that you attach to form an audio processing chain.

A flow diagram that shows an app using an audio engine in a real time context. The audio flows from the source file in the app to a player node, a mixer node, and an output node before reaching the device’s speaker or connected headphones.

You can connect, disconnect, and remove audio nodes during runtime with minor limitations. Removing an audio node that has differing channel counts, or that’s a mixer, can break the graph. Reconnect audio nodes only when they’re upstream of a mixer.

By default, Audio Engine renders to a connected audio device in real time. You can configure the engine to operate in manual rendering mode when you need to render at, or faster than, real time. In that mode, the engine disconnects from audio devices and your app drives the rendering.

## Create an Engine for Audio File Playback
To play an audio file, you create an AVAudioFile with a file that’s open for reading. Create an audio engine object and an AVAudioPlayerNode instance, and then attach the player node to the engine. Next, connect the player node to the audio engine’s output node. The engine performs audio output through an output node, which is a singleton that the engine creates the first time you access it.

'''Swift
let audioFile = /* An AVAudioFile instance that points to file that's open for reading. */
let audioEngine = AVAudioEngine()
let playerNode = AVAudioPlayerNode()


// Attach the player node to the audio engine.
audioEngine.attach(playerNode)


// Connect the player node to the output node.
audioEngine.connect(playerNode, 
                    to: audioEngine.outputNode, 
                    format: audioFile.processingFormat)

'''

Then schedule the audio file for full playback. The callback notifies your app when playback completes.

'''Swift
playerNode.scheduleFile(audioFile, 
                        at: nil, 
                        completionCallbackType: .dataPlayedBack) { _ in
    /* Handle any work that's necessary after playback. */
}
'''
Before you play the audio, start the engine.

'''Swift
do {
    try audioEngine.start()
    playerNode.play()
} catch {
    /* Handle the error. */
}
'''
When you’re done, stop the player and the engine.
'''Swift
playerNode.stop()
audioEngine.stop()
'''

