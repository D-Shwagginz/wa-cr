@[Link("raylib")]
lib Rcamera
  fun get_camera_forward = GetCameraForward(camera : Raylib::Camera3D*) : Raylib::Vector3
  fun get_camera_up = GetCameraUp(camera : Raylib::Camera3D*) : Raylib::Vector3
  fun get_camera_right = GetCameraRight(camera : Raylib::Camera3D*) : Raylib::Vector3
  fun camera_move_forward = CameraMoveForward(camera : Raylib::Camera3D*, distance : LibC::Float, moveInWorldPlane : Bool)
  fun camera_move_up = CameraMoveUp(camera : Raylib::Camera3D*, distance : LibC::Float)
  fun camera_move_right = CameraMoveRight(camera : Raylib::Camera3D*, distance : LibC::Float, moveInWorldPlane : Bool)
  fun camera_move_target = CameraMoveToTarget(camera : Raylib::Camera3D*, delta : LibC::Float)
  fun camera_yaw = CameraYaw(camera : Raylib::Camera3D*, angle : LibC::Float, rotateAroundTarget : Bool)
  fun camera_pitch = CameraPitch(camera : Raylib::Camera3D*, angle : LibC::Float, lockView : Bool, rotateAroundTarget : Bool, rotateUp : Bool)
  fun camera_roll = CameraRoll(camera : Raylib::Camera3D*, angle : LibC::Float)
end
