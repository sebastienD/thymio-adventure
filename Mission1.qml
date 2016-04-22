import QtQuick 2.0
import Qt.labs.controls 1.0
import Qt3D.Core 2.0
import Qt3D.Render 2.0
import "qrc:/thymio-ar" as AR
import "qrc:/storytelling"

Item {

	property bool grotteVisible: false

	AR.Vision {
		id: vision
		anchors.fill: parent

		landmarkFileNames: [
			":/assets/marker.xml"
		]

		Entity {
			components: [
				SceneLoader {
					source: "/models/Grotte.qgltf"
				},
				Transform {
					scale: grotteVisible ? 0.001 : 0
					rotationX: 90
				}
			]
		}
	}

	Dialogue {
		// TODO: aseba connection
		// TODO: black screen
		SystemSays { message: "Connecting..." }
		SystemSays { message: "Waiting for answer from parallel world…" }
		SystemSays { message: "Connection established, code name LEVIGO" }
		ThymioSays { message: "Is someone there?" }
		// TODO: spot light, blurred image
		Choice {
			ThymioSays { message: "Hello, can anyone hear me?" }
			choices: ["Who is talking?"]
		}
		ThymioSays { message: "My name is Thymio." }
		ThymioSays { message: "The connection is… unstable…" }
		// TODO: The screen could blink, blur a bit more, freeze…
		ThymioSays { message: "Please… synchronise… tablet… with me…" }
		Wait {
			SystemSays { message: "Aim Thymio with the tablet" }
			// TODO: detect Thymio at the center of the screen, image is clearer when Thymio is at the center
			until: vision.robotPose !== vision.invalidPose
		}
		// TODO: the screen becomes clear
		ThymioSays { message: "Much better, thank you." }
		Choice {
			ThymioSays { message: "Do you know what I am?" }
			choices: ["Not really"]
		}
		ThymioSays { message: "I am an exploration robot, or at least I think." }
		ThymioSays { message: "It seems that I am running in safe mode." }
		ThymioSays { message: "I cannot control my motors and I don’t see anything." }
		ThymioSays { message: "Would you help me?" }
		Wait {
			onEnabledChanged: if (enabled) {
				vision.calibrationRunning = true;
			}
			SystemSays { message: "Place marker number 1 on the center of the table and aim to it with the tablet" }
			until: vision.calibrationProgress === 1.0 && !vision.calibrationRunning
		}
		ThymioSays { message: "The last thing I remember is entering in a cave." }
		ThymioSays {
			onEnabledChanged: if (enabled) {
				grotteVisible = true;
			}
			message: "Oh yeah, that’s it. A cave. It seems cold."
		}
	}

}