package {
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.display.MovieClip;

	/**
	 * @author amcintosh-cc
	 */
	[SWF(backgroundColor="0x000000")]
	public class Pong extends MovieClip {
		private var ball : Bitmap = null;
		private var cpuPaddle : Bitmap = null;
		private var playerPaddle : Bitmap = null;
		private var oLoaderPlayer : Loader = new Loader();
		private var oLoaderCpu : Loader = new Loader();
		private var oLoaderBall : Loader = new Loader();
		
		private var ballSpeedX : int = -3;
		private var ballSpeedY : int = -2;
		private var cpuPaddleSpeed : int = 3;
		private var playerScore : int = 0;
		private var cpuScore : int = 0;
		private var playerScoreText : TextField = new TextField();
		private var cpuScoreText : TextField = new TextField();

		public function Pong() {
			oLoaderPlayer.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			oLoaderBall.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			oLoaderBall.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError); 
			oLoaderPlayer.load(new URLRequest("../img/Paddle.png"));		
			oLoaderBall.load(new URLRequest("../img/Ball.png"));

		}

		private function onIOError(event : IOErrorEvent) : void {
			trace(event);
		}

		private function loaded(event : Event) : void {
			ball = Bitmap(oLoaderBall.content);
			cpuPaddle = Bitmap(oLoaderPlayer.content);
			playerPaddle = new Bitmap(cpuPaddle.bitmapData);
trace("ball is : " + ball);
			if (ball != null && cpuPaddle != null && playerPaddle != null ) {
				oLoaderPlayer.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaded);
				oLoaderCpu.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaded);
				oLoaderBall.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaded);
				oLoaderPlayer = oLoaderCpu = oLoaderBall = null;

				addChild(ball);
				addChild(cpuPaddle);
				addChild(playerPaddle);
				addChild(playerScoreText);
				addChild(cpuScoreText);
				stage.addEventListener(Event.ENTER_FRAME, loop);
				
				ball.x = 275;
				ball.y = 200;
				playerPaddle.x = 20;
				playerPaddle.y = 200;
				cpuPaddle.x = 530;
				cpuPaddle.y = 200;
				playerScoreText.x = 37;
				playerScoreText.textColor = 0xFFFFFF;
				cpuScoreText.x = 380;
				cpuScoreText.textColor = 0xFFFFFF;
				updateTextFields();
			}
		}

		
		private function calculateBallAngle(paddleY : Number, ballY : Number) : Number {
			var ySpeed : Number = 5 * ( (ballY - paddleY) / 25 );

			return ySpeed;
		}

		private function updateTextFields() : void {
			playerScoreText.text = ("Player Score: " + playerScore);
			cpuScoreText.text = ("CPU Score: " + cpuScore);
		}

		private function loop(e : Event) : void {
			if ( playerPaddle.hitTestObject(ball) == true ) {
				if (ballSpeedX < 0) {
					ballSpeedX *= -1;
					ballSpeedY = calculateBallAngle(playerPaddle.y, ball.y);
				}
			} else if (cpuPaddle.hitTestObject(ball) == true ) {
				if (ballSpeedX > 0) {
					ballSpeedX *= -1;
					ballSpeedY = calculateBallAngle(cpuPaddle.y, ball.y);
				}
			}

			if (cpuPaddle.y < ball.y - 10) {
				cpuPaddle.y += cpuPaddleSpeed;
			} else if (cpuPaddle.y > ball.y + 10) {
				cpuPaddle.y -= cpuPaddleSpeed;
			}

			playerPaddle.y = mouseY;

			if (playerPaddle.y - playerPaddle.height / 2 < 0) {
				playerPaddle.y = playerPaddle.height / 2;
			} else if (playerPaddle.y + playerPaddle.height / 2 > stage.stageHeight) {
				playerPaddle.y = stage.stageHeight - playerPaddle.height / 2;
			}

			ball.x += ballSpeedX;
			ball.y += ballSpeedY;

			if (ball.x <= ball.width / 2) {
				ball.x = ball.width / 2;
				ballSpeedX *= -1;
				cpuScore++;
				updateTextFields();
			} else if (ball.x >= stage.stageWidth - ball.width / 2) {
				ball.x = stage.stageWidth - ball.width / 2;
				ballSpeedX *= -1;
				playerScore++;
				updateTextFields();
			}

			if (ball.y <= ball.height / 2) {
				ball.y = ball.height / 2;
				ballSpeedY *= -1;
			} else if (ball.y >= stage.stageHeight - ball.height / 2) {
				ball.y = stage.stageHeight - ball.height / 2;
				ballSpeedY *= -1;
			}
		}
	}
}
