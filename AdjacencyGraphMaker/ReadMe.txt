Adjacency Graph Maker
(For OS Processes and Resources)

		Created by: Chris Herzberg
			 Major:	Computer Engineering Senior at University of North Texas
	  School email: ChristopherHerzberg@my.unt.edu
	Personal email: Christopher.T.Herzberg@gmail.com


Important:
	The .exe comes with an included pack file. Ensure that the exe and pack file are both located
	in the same folder or the program will not run.

I originally made this tool to assist in a group project for my Intro to Operating Systems Class.
As such, its functionality is currently limited to the scope described below. If you feel
that the concept behind this tool could be useful to you, I would be happy to alter or expand
its functionality. Please feel free to contact me if you experience any issues or bugs, or if
you have any questions, requests, or other feedback.

Current Features
	- Add/remove graph and resource nodes using simple point & click input
	- Set the number of resources for each resource node (currently between 1 & 4)
	- Add/remove connections between process & resource nodes
	- An adjacency matrix will be dynamically created as the graph is being worked on
	- Preview and generate an output file with the following information:
		- Number of processes and resources
		- Number of total resource units for each unit
		- The adjacency matrix

Usage:
	Note: Hovering the mouse over any button/toggle will display a tooltip indicating its use.

	The interface is divided into 3 sections:
	
		- The graph (left side of the screen)
		
			- Contains 6 buttons that can be toggled with a mouse click or hotkeys (number keys 1-6)
			The buttons are as follows:
				- Process (+)
					When toggled, click anywhere in the white square to place a process node.
					
				- Resrouce (+)
					When toggled, click anywhere in the white square to placce a resource node.
					
				- Connection (+)
					When toggled, click on any node to set it as the 'from' node, and then click on 
					a second 'to' node to create a directed edge between both nodes.	
					
				- Node (-)
					When toggled, click on any process or resource node to remove it. If it has
					any connetions, they will be automatically removed along with the node.
					
				- Connection (-)
					When Toggled, click on any connection edge to remove it.
					
				- Set Resource Units
					When toggled, click on any resource node, and then type in the provided console 
					the number of resource units you would like it to have, followed by the enter key. 
					You can also select more than one node at a time.

		- The matrix (right side of the screen)
		
			- This is where the matrix will be rendered when graph nodes/connections are placed
			- Contains 4 buttons:
				- Options
					- Program options
				- Preview File Output
					- Displays what will be written to an output file given the current graph data
						Note: this does not auto update along with the graph. You must click the 
						'Preview File Output' button again for it to update with any new data.
				
				- Generate Output File
					- After clicking, the console will prompt you to enter a file name. If you only
					type a file name, the file will be created in whichever folder the exe is located. 
					Optionally, you can also type the path to an alternate directory when typing in the 
					file name. (e.g., c:/users/username/desktop/file_name.txt)
				
				- About
					Brief description of the tool and its features, as well as my contact info.

		- Console (bottom of the screen)
			
			- The console will display prompts as appropriate when various buttons are toggled.
			- Click next to the arrow indicator to begin typing input when necessary, and press enter
			to submit.
		
