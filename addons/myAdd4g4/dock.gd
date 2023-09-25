# ========================================================
# 名称：dock.tscn
# 类型：面板
# 简介：myAdd for Godot 4.0 的节点添加面板
# 作者：巽星石
# Godot版本：4.0.2-stable (official)
# 创建时间：2023-04-20 17:59:41
# 最后修改时间：2023年4月20日23:50:51
# ========================================================
@tool
extends TabContainer


var NodeAddPlugin = preload("res://addons/myAdd4g4/class/sub_class/NodeAddPlugin.gd").new()


var pages = {
	page1 = [
		{
			title = "基类",
			clas =["Control"]
		},
		{
			title = "容器",
			clas = ["Container","AspectRatioContainer","BoxContainer","VBoxContainer","ColorPicker",
			"HBoxContainer","CenterContainer","FlowContainer","HFlowContainer","VFlowContainer",
			"GraphNode","GridContainer","SplitContainer","HSplitContainer","VSplitContainer","MarginContainer"
			,"PanelContainer","ScrollContainer","SubViewportContainer","TabContainer"]
		},
		{
			title = "按钮",
			clas =["Button","MenuButton","CheckBox","CheckButton","LinkButton","TextureButton","OptionButton","ColorPickerButton"]
		},
		{
			title = "文本",
			clas = ["LineEdit","TextEdit","CodeEdit","Label","RichTextLabel"]
		},
		{
			title = "项列表",
			clas = ["Tree","ItemList"]
		},
		{
			title = "背景",
			clas = ["NinePatchRect","Panel"]
		},
		{
			title = "范围",
			clas = ["HScrollBar","VScrollBar","HSlider","VSlider","ProgressBar","TextureProgressBar","SpinBox"]
		},
		{
			title = "其他",
			clas = ["HSeparator","VSeparator","MenuBar","ReferenceRect","TabBar","TextureRect","VideoStreamPlayer","ColorRect","GraphEdit"]
		},
		{
			title = "窗体",
			clas = ["Window","AcceptDialog","ConfirmationDialog","FileDialog","Popup","PopupMenu","PopupPanel","SubViewport"]
		}
	],
	page2 = [
		{
			title = "基类",
			clas =["Node2D"]
		},
		{
			title = "地图",
			clas =["TileMap"]
		},
		{
			title = "相机",
			clas =["Camera2D"]
		},
		{
			title = "灯光",
			clas =["DirectionalLight2D","PointLight2D","LightOccluder2D"]
		},
		{
			title = "图片",
			clas =["Sprite2D","AnimatedSprite2D"]
		},
		{
			title = "网格",
			clas =["MeshInstance2D","MultiMeshInstance2D"]
		},
		{
			title = "声音",
			clas =["AudioStreamPlayer2D","AudioStreamPlayer","AudioListener2D"]
		},
		{
			title = "物理和碰撞",
			clas =["StaticBody2D","AnimatableBody2D","CharacterBody2D","RigidBody2D","PhysicalBone2D","Area2D","CollisionPolygon2D","CollisionShape2D",]
		},
		{
			title = "路径与跟随",
			clas =["Path2D","PathFollow2D"]
		},{
			title = "画布层与视差",
			clas =["CanvasLayer","ParallaxBackground"]
		},
		{
			title = "形状、标记与射线",
			clas =["Line2D","Marker2D","Polygon2D","RayCast2D","ShapeCast2D"]
		},
		{
			title = "导航",
			clas =["NavigationLink2D","NavigationRegion2D","NavigationAgent2D","NavigationObstacle2D"]
		},
		{
			title = "屏幕范围可见性控制",
			clas =["VisibleOnScreenNotifier2D","VisibleOnScreenEnabler2D"]
		},
		{
			title = "粒子",
			clas =["CPUParticles2D","GPUParticles2D"]
		},
		{
			title = "关节",
			clas =["DampedSpringJoint2D","GrooveJoint2D","PinJoint2D"]
		},
		{
			title = "其他",
			clas =["CanvasGroup","CanvasModulate","ParallaxLayer","RemoteTransform2D","TouchScreenButton",]
		}
	],
	page3 = [
		{
			title = "基类",
			clas =["Node3D"]
		},
		{
			title = "地图",
			clas =["GridMap"]
		},
		{
			title = "相机",
			clas =["Camera3D"]
		},
		{
			title = "灯光",
			clas =["DirectionalLight3D","OmniLight3D","SpotLight3D"]
		},
		{
			title = "图片",
			clas =["Sprite3D","AnimatedSprite3D"]
		},
		{
			title = "文本",
			clas = ["Label3D"]
		},
		{
			title = "网格",
			clas =[
				"MeshInstance3D","MultiMeshInstance3D",
				"BoxMesh","CapsuleMesh","CylinderMesh","PlaneMesh",
				"QuadMesh","PointMesh","PrismMesh","RibbonTrailMesh",
				"SphereMesh","TextMesh","TorusMesh","TubeTrailMesh"
			]
		},
		{
			title = "CSG",
			clas =["CSGPrimitive3D","CSGMesh3D","CSGSphere3D","CSGBox3D","CSGCylinder3D","CSGTorus3D","CSGPolygon3D","CSGCombiner3D",]
		},
		{
			title = "声音",
			clas =["AudioStreamPlayer3D","AudioStreamPlayer","AudioListener3D"]
		},
		{
			title = "物理和碰撞",
			clas =["StaticBody3D","AnimatableBody3D","RigidBody3D","VehicleBody3D","CharacterBody3D","Area3D","CollisionShape3D","CollisionPolygon3D"]
		},
		{
			title = "路径与跟随",
			clas =["Path3D","PathFollow3D",]
		},
		{
			title = "形状、标记与射线",
			clas =["Marker3D","RayCast3D","ShapeCast3D"]
		},
		{
			title = "导航",
			clas =["NavigationRegion3D","NavigationLink3D","NavigationAgent3D","NavigationObstacle3D"]
		},
		{
			title = "屏幕范围可见性控制",
			clas =["VisibleOnScreenNotifier3D","VisibleOnScreenEnabler3D"]
		},
		{
			title = "粒子",
			clas =[
				"GPUParticles3D","CPUParticles3D",
				"GPUParticlesCollision3D","GPUParticlesCollisionBox3D","GPUParticlesCollisionSphere3D",
				"GPUParticlesCollisionSDF3D","GPUParticlesCollisionHeightField3D","GPUParticlesAttractor3D",
				"GPUParticlesAttractorBox3D","GPUParticlesAttractorSphere3D","GPUParticlesAttractorVectorField3D",
			]
		},
		{
			title = "关节",
			clas =["PinJoint3D","HingeJoint3D","SliderJoint3D","ConeTwistJoint3D","Generic6DOFJoint3D"]
		},
		{
			title = "其他",
			clas =[
				"Skeleton3D","ImporterMeshInstance3D","VisualInstance3D","GeometryInstance3D",
				"OccluderInstance3D","ReflectionProbe","VoxelGI","LightmapGI","LightmapProbe",
				"Decal","RootMotionView","SpringArm3D","PhysicalBone3D","SoftBody3D",
				"BoneAttachment3D","VehicleWheel3D","FogVolume","RemoteTransform3D","OpenXRHand","SkeletonIK3D"
			]
		},
		{
			title = "XR",
			clas =["XRCamera3D","XRNode3D","XRController3D","XRAnchor3D","XROrigin3D"]
		}
	],
	page4 = [
		{
			title = "计时器",
			clas =["Timer"]
		},{
			title = "环境",
			clas =["WorldEnvironment",]
		},{
			title = "动画",
			clas =["AnimationPlayer","AnimationTree",]
		},{
			title = "网络与多用户",
			clas =["HTTPRequest","MultiplayerSpawner","MultiplayerSynchronizer",]
		},{
			title = "其他",
			clas =["ResourcePreloader","ShaderGlobalsOverride"]
		}
	]
}


func _ready():
	for page in pages:
		for gup in pages[page]:
			add_group(int(page.replace("page","")),gup["clas"],gup["title"])

# 创建分组按钮
func add_group(page:int,class_arr:PackedStringArray,gup_title:String):
	var vbox = get_node("%Vbox" + str(page)) # 相应分页的VBox
	var hflow = get_node("%HFlow" + str(page)) # 相应分页的VBox
	# 分组标题
	var title_lab = Label.new() 
	title_lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lab.text = gup_title
	vbox.add_child(title_lab)
	# 两列的GridContainer
	var grid = GridContainer.new()
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	# 添加按钮
	var ctrs = class_arr
	for ctr in ctrs:
		if ClassDB.can_instantiate(ctr): # 必须是可以实例化的
			var btn = Button.new()
			btn.text = ctr
			btn.icon = NodeAddPlugin.get_icon(ctr)
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			btn.pressed.connect(btn_click.bind(page,title_lab.text,ctr))
			grid.add_child(btn)
	if grid.get_child_count() == 1:
		grid.columns = 1
	vbox.add_child(grid)
	# 添加分组导航按钮
	var nav_btn = Button.new()
	nav_btn.text = gup_title
	nav_btn.pressed.connect(nav_btn_pressed.bind(gup_title,vbox))
	hflow.add_child(nav_btn)

func nav_btn_pressed(gup_title:String,vbox:VBoxContainer):
		var scroll:ScrollContainer = vbox.get_parent()
		var childs = vbox.get_children()
		for child in childs:
			if child is Label and child.text == gup_title:
				scroll.scroll_vertical = child.position.y

# 按钮点击处理
func btn_click(page:int,gup_title:String,btn_title:String):
	match gup_title:
		"网格":
			if btn_title.ends_with("Mesh"):
				if ClassDB.class_exists(btn_title):
					# 创建实例
					var mesh = ClassDB.instantiate(btn_title)
					var ins = MeshInstance3D.new()
					ins.mesh = mesh
					ins.name = btn_title
					# 添加
					if NodeAddPlugin.current_scene_is_empty():
						NodeAddPlugin.empty_scene_add_root(ins)
					else:
						NodeAddPlugin.select_add_child(ins)	
		_:
			if NodeAddPlugin.current_scene_is_empty():
				NodeAddPlugin.empty_scene_add_root_by_class(btn_title)
			else:
				NodeAddPlugin.select_add_child_by_class(btn_title)
	match page:
		1,2:
			NodeAddPlugin.change_to_mainscreen("2D")
		3:
			NodeAddPlugin.change_to_mainscreen("3D")
