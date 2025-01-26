# Push Or Perish
This project is a simple reflex-based game called *Push and Perish, developed using the MSP430G2553* microcontroller. Players must watch the countdown on a 7-segment display and press a button at the right time to win.

![IMG-20250126-WA0005](https://github.com/user-attachments/assets/9f9817aa-c53f-4cd2-a065-e15a1da6312f)

## Game Rules:
- Countdown: The 7-segment display counts down from 3, 2, 1, 0.
- Winning Conditions:
  - If a player presses the button before reaching 0, the other player automatically wins.
  - If both players wait until 0 and then press, the first player to press wins.
- LED Indicators:
  - The winning player’s LED lights up.
- Game Restart:
  - After determining a winner, the game waits 3 seconds and restarts automatically.

## Hardware Components

| Component  | Connection Ports | Description |
|------------|----------------|-------------|
| *MSP430G2553* | Port 1, Port 2 | Microcontroller |
| *7-Segment Display* | P1.0 - P1.7 | Display numbers |
| *Buttons (x2)* | P2.0, P2.1 | Player inputs |
| *LEDs (x2)* | P2.2, P2.3 | Winner indication |
| *Resistors (10kΩ, 220Ω)* | Pull-up and LED resistors | Safe operation |


## Team Members
| Name - Surname |  Github Account | Department |
| -------------- | --------------- | ---------- |
| Arda YILDIZ       | [29ardayildiz](https://github.com/29ardayildiz) | CENG |
| Barkın SARIKARTAL | [barkinsarikartal](https://github.com/barkinsarikartal)   | CENG |
| Çağdaş GÜLEÇ       | [Cagdas-Gulec](https://github.com/Cagdas-Gulec) | CENG |
| Doğukan POYRAZ          | [dogukanpoyraz](https://github.com/dogukanpoyraz)       | CENG |

## Documents 
- [Project Report](https://github.com/29ardayildiz/Push_Or_Perish/blob/main/Documents/Push_Or_Perish_Report.pdf)

## Project Video
- [Project Demo](https://www.youtube.com/watch?v=0pIQgclVjL4)
