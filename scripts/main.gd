
extends Node2D

var player := Vector2(360, 420)
var enemy := Vector2(570, 300)

var player_hp := 100
var enemy_hp := 100

var speed := 230.0
var joystick := Vector2.ZERO
var joystick_origin := Vector2.ZERO
var move_touch_id := -1
var attack_held := false
var attack_cooldown := 0.0
var message := "神域之战：击败暗影魔物！"

func _ready():
    player = get_viewport_rect().size / 2
    enemy = player + Vector2(180, -100)

func _process(delta):
    attack_cooldown = maxf(0.0, attack_cooldown - delta)

    var direction := Input.get_vector(
        "ui_left", "ui_right", "ui_up", "ui_down"
    )

    if joystick.length() > 0.1:
        direction = joystick

    player += direction * speed * delta

    var size = get_viewport_rect().size
    player.x = clampf(player.x, 30, size.x - 30)
    player.y = clampf(player.y, 120, size.y - 35)

    if enemy_hp > 0:
        var chase = (player - enemy).normalized()
        if enemy.distance_to(player) > 48:
            enemy += chase * 75.0 * delta

        if attack_held and attack_cooldown <= 0:
            attack_cooldown = 0.45
            if enemy.distance_to(player) < 115:
                enemy_hp = max(0, enemy_hp - 20)
                message = "命中！暗影魔物受到攻击！"
            else:
                message = "攻击距离不够！"
    else:
        message = "胜利！暗影魔物已被击败！"

    queue_redraw()

func _input(event):
    if event is InputEventScreenTouch:
        if event.pressed:
            if event.position.x < get_viewport_rect().size.x * 0.55:
                move_touch_id = event.index
                joystick_origin = event.position
                joystick = Vector2.ZERO
            else:
                attack_held = true
        else:
            if event.index == move_touch_id:
                move_touch_id = -1
                joystick = Vector2.ZERO
            elif event.position.x >= get_viewport_rect().size.x * 0.55:
                attack_held = false

    elif event is InputEventScreenDrag:
        if event.index == move_touch_id:
            joystick = (
                event.position - joystick_origin
            ).limit_length(55) / 55.0

func _draw():
    var size = get_viewport_rect().size

    # 像素风神域地面
    draw_rect(Rect2(Vector2.ZERO, size), Color("#172b28"))

    for x in range(-200, int(size.x) + 200, 80):
        for y in range(100, int(size.y) + 100, 80):
            var p = Vector2(x + (y % 160) / 2, y)
            var diamond = PackedVector2Array([
                p + Vector2(0, -40),
                p + Vector2(40, 0),
                p + Vector2(0, 40),
                p + Vector2(-40, 0)
            ])
            draw_colored_polygon(diamond, Color("#24433a"))

    # 暗影魔物
    if enemy_hp > 0:
        draw_rect(
            Rect2(enemy - Vector2(13, 20), Vector2(26, 30)),
            Color("#542c83")
        )
        draw_rect(
            Rect2(enemy - Vector2(9, 30), Vector2(18, 15)),
            Color("#a34aff")
        )
        draw_rect(
            Rect2(enemy - Vector2(9, 45), Vector2(18, 4)),
            Color.RED
        )
        draw_rect(
            Rect2(enemy - Vector2(12, 55), Vector2(24, 4)),
            Color("#222222")
        )
        draw_rect(
            Rect2(enemy - Vector2(12, 55), Vector2(24.0 * enemy_hp / 100.0, 4)),
            Color("#ff4545")
        )

    # 玩家像素角色
    draw_rect(
        Rect2(player - Vector2(12, 10), Vector2(24, 30)),
        Color("#2476cf")
    )
    draw_rect(
        Rect2(player - Vector2(10, 30), Vector2(20, 20)),
        Color("#f1c28b")
    )
    draw_rect(
        Rect2(player - Vector2(11, 34), Vector2(22, 8)),
        Color("#202030")
    )
    draw_rect(
        Rect2(player - Vector2(12, -20), Vector2(24, 5)),
        Color("#55aaff")
    )

    # 状态栏
    draw_rect(Rect2(15, 15, size.x - 30, 75), Color("#101827"))
    draw_string(ThemeDB.fallback_font, Vector2(28, 43),
        "SHADOW ERA", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color.WHITE)
    draw_string(ThemeDB.fallback_font, Vector2(28, 72),
        "HP: %d / 100" % player_hp,
        HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color("#55ff88"))

    draw_string(ThemeDB.fallback_font, Vector2(15, 112),
        message, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.WHITE)

    # 虚拟摇杆
    var joy_pos = joystick_origin if move_touch_id != -1 else Vector2(85, size.y - 100)
    draw_circle(joy_pos, 43, Color("#657b8990"))
    draw_circle(joy_pos + joystick * 27, 17, Color("#d5eaff"))

    # 攻击按钮
    var attack_pos = Vector2(size.x - 85, size.y - 105)
    draw_circle(attack_pos, 48, Color("#b34242"))
    draw_string(ThemeDB.fallback_font,
        attack_pos + Vector2(-27, 7),
        "攻击", HORIZONTAL_ALIGNMENT_LEFT, -1, 21, Color.WHITE)
