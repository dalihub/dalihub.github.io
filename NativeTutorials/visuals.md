# Visuals

Visuals are the main building block for controls.

You can create a reusable rendering logic, which can be used by all controls, using visuals.</br>
The content rendering can be controlled using properties.</br>
Visuals also respond to view size and color changes, and can perform clipping at the renderer level.</br>

As an example, images, icons and text are added to buttons using visuals.</br>
A control has 3 states - NORMAL, FOCUSED, and DISABLED. Additionally, buttons have 2 substates: SELECTED and UNSELECTED.</br>
The button's appearance can be modified by setting properties for the various 'state' visuals.</br>
Each state and sub-state has mandatory visuals, and several states can share a visual.</br>
When the button is clicked, it goes from the unselected state to the selected state.</br>
The unselected state visuals are replaced by the selected state visuals.</br>
When the button is disabled, the background, button, and selected state visuals are replaced by the disabled state visuals</br>
