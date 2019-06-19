# BoneGizmo

Plugin for Godot Engine
Simple Gizmo so you can edit bone transforms easily.

## How to use:

1. Enable plugin.
2. Add a BoneGizmo node to your scene.
3. Select BoneGizmo in scene tree and ensure it's properties points to a valid
   Skeleton node and an optional AnimationPlayer node.
4. When you select a BoneGizmo node
	- The BoneGizmo dock enables and loads up the selected BoneGizmo.
	- You can then search for a bone. A highlighted bone is a selected bone.
	- Bone filters are persisted via metadata for you to continue your work at
	  another time.
5. Hit *Run Gizmo* in the BoneGizmo dock.
6. Translate, rotate, and scale your selected bone.

## Caveats

You should disable *Run Gizmo* when an animation is playing.

BoneGizmo nodes will remain in your scene tree.
