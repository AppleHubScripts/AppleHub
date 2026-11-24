-- ===== APPLE BLOX · PARTE A de 2 (cole logo ABAIXO do script do painel, no MESMO script) =====
local AHX = {}

------------------------------------------------------------------
-- A1) ESTADO, TEMAS E FONTES
------------------------------------------------------------------
;(function()
	if not (S and GM and showPage and addPage and toggle and group and main and applyGlass and setShown) then
		warn("[Apple Blox] Cole esta parte DEPOIS do script do painel, no mesmo script.")
		AHX.fail = true
		return
	end
	AHX.NEW = {
		Theme = "Copper", ThemeAuto = false, DayTheme = "Apple", NightTheme = "Midnight", UseCustomAcc = false, AccR = 196, AccG = 149, AccB = 108,
		Compact = false, Focus = false, Density = "Normal", TouchBig = false, SwipeTabs = true, LongPress = true, Haptic = true, ToastInside = true,
		GlassAlpha = 12, Blur = false, BlurSize = 10, Cards3D = true, Stagger = true, Skeleton = true, PartType = "Runes",
		Ambient = false, AmbientId = "", AmbientVol = 20, UpdateUrl = "", TabOrder = {}, Fav = {}, SaveCheck = true,
	}
	for k, v in pairs(AHX.NEW) do if S[k] == nil then S[k] = v end end
	pcall(function()
		if isfile and isfile(FILE) then
			local d = HS:JSONDecode(readfile(FILE))
			for k, v in pairs(AHX.NEW) do if d[k] ~= nil and type(d[k]) == type(v) then S[k] = d[k] end end
		end
	end)
	local function C(h) return Color3.fromHex(h) end
	AHX.C = C
	local function Th(bg, side, card, line, text, sub, off, dark, acc) return {bg = bg, side = side, card = card, line = line, text = text, sub = sub, off = off, dark = dark, acc = acc} end
	AHX.THEMES = {
		Copper = Th("#181412", "#1d1916", "#221d1a", "#322b26", "#ece4dc", "#8c8279", "#3e3732", "#1c1510", "#c4956c"),
		Apple = Th("#101112", "#151617", "#1a1b1d", "#2a2c2f", "#f5f5f7", "#8e8e93", "#3a3a3c", "#0b1a0c", "#8bd17c"),
		Mist = Th("#f5f5f7", "#ebebee", "#ffffff", "#d8d8de", "#1d1d1f", "#6e6e73", "#cfcfd6", "#ffffff", "#2f9e44"),
		Midnight = Th("#0e1118", "#12161f", "#171c27", "#242b3a", "#e6ecf7", "#7d8aa3", "#2f3748", "#0a1020", "#5b8cff"),
		Ocean = Th("#0a1519", "#0e1c22", "#12252d", "#1d3a45", "#e3f6fb", "#78a3b0", "#264653", "#06161c", "#38c6e8"),
		Sakura = Th("#1a1216", "#21171c", "#291d23", "#3b2a33", "#fbeaf1", "#a98796", "#4a3540", "#2a0f1a", "#ff8fb8"),
		Dracula = Th("#1b1c26", "#20212e", "#272938", "#363950", "#f8f8f2", "#8a8fb5", "#41445e", "#1b1226", "#bd93f9"),
		Forest = Th("#0e1510", "#121b14", "#17231a", "#233829", "#e8f5ea", "#7fa088", "#2d4535", "#08140c", "#6fcf84"),
		Sunset = Th("#1a1210", "#21171a", "#291c1d", "#3c2a29", "#ffefe6", "#b58f85", "#4b3532", "#2a1008", "#ff8a5b"),
		AMOLED = Th("#000000", "#070707", "#0e0e0e", "#1f1f1f", "#f2f2f2", "#808080", "#2a2a2a", "#000000", "#e8e8e8"),
		Slate = Th("#16181c", "#1b1e23", "#21252b", "#2f343c", "#e7eaee", "#8a929d", "#3a4049", "#12151a", "#8fa3b8"),
		Sand = Th("#f4efe6", "#e9e2d4", "#fffaf0", "#d9cfba", "#2b2418", "#7d725c", "#cfc4ac", "#ffffff", "#c2793a"),
	}
	AHX.THEME_ORDER = {"Copper", "Apple", "Mist", "Midnight", "Ocean", "Sakura", "Dracula", "Forest", "Sunset", "AMOLED", "Slate", "Sand"}
	ACCENTS.Apple = C("#8bd17c")
	ACC_ORDER[#ACC_ORDER + 1] = "Apple"
	local function repaintAll()
		rebind()
		for _, f in ipairs(repaints) do pcall(f) end
		syncAll()
	end
	AHX.repaintAll = repaintAll
	AHX.applyTheme = function(name)
		local th = AHX.THEMES[name]
		if not th then return end
		S.Theme = name
		for k, v in pairs(th) do if k ~= "acc" then T[k] = C(v) end end
		T.acc = S.UseCustomAcc and Color3.fromRGB(S.AccR, S.AccG, S.AccB) or C(th.acc)
		repaintAll()
		if AHX.themeStrokes then AHX.themeStrokes() end
	end
	AHX.setAccColor = function(col) T.acc = col; repaintAll() end
	-- mais fontes
	local boldMap = {Gotham = "GothamBold", SourceSans = "SourceSansBold", SourceSansLight = "SourceSansBold", Arial = "ArialBold"}
	AHX.FONTS = {"Pixel", "Clean", "Mono"}
	for _, n in ipairs({"Gotham", "SourceSans", "SourceSansLight", "Roboto", "RobotoCondensed", "RobotoMono", "Ubuntu", "Nunito", "Oswald", "Jura", "Michroma",
		"FredokaOne", "JosefinSans", "TitilliumWeb", "Sarpanch", "SciFi", "Highway", "Cartoon", "Bangers", "LuckiestGuy", "Merriweather", "Garamond", "Bodoni",
		"Fondamento", "Antique", "Fantasy", "Creepster", "IndieFlower", "PatrickHand", "Kalam", "AmaticSC", "SpecialElite", "DenkOne", "PermanentMarker", "Arial"}) do
		local ok, f = pcall(function() return Enum.Font[n] end)
		if ok and f then
			local fb = f
			if boldMap[n] then pcall(function() fb = Enum.Font[boldMap[n]] end) end
			FONTS[n] = {f, fb}
			AHX.FONTS[#AHX.FONTS + 1] = n
		end
	end
end)()

------------------------------------------------------------------
-- A2) IDIOMAS (traduz o painel inteiro, ao vivo)
------------------------------------------------------------------
;(function()
	if AHX.fail then return end
	local LC = {"pt", "en", "es", "fr", "de", "it", "ru", "tr", "id", "zh", "ja", "ko", "ar", "vi", "pl", "nl", "uk", "hi"}
	local LN = {"Português", "English", "Español", "Français", "Deutsch", "Italiano", "Русский", "Türkçe", "Bahasa Indonesia", "中文", "日本語", "한국어", "العربية", "Tiếng Việt", "Polski", "Nederlands", "Українська", "हिन्दी"}
	local LI = {}
	for i, c in ipairs(LC) do LI[c] = i end
	AHX.LC, AHX.LN = LC, LN
	local REV, PFX = {}, {}
	local function D(packed, prefix)
		local arr = {}
		for part in string.gmatch(packed, "[^|]+") do arr[#arr + 1] = part end
		for _, s in ipairs(arr) do
			local k = s:lower()
			if REV[k] == nil then REV[k] = arr end
		end
		if prefix then PFX[#PFX + 1] = arr end
	end
	-- ordem: pt|en|es|fr|de|it|ru|tr|id|zh|ja|ko|ar|vi|pl|nl|uk|hi
	D("Bem-vindo de volta, |Welcome back, |Bienvenido de nuevo, |Bon retour, |Willkommen zurück, |Bentornato, |С возвращением, |Tekrar hoş geldin, |Selamat datang kembali, |欢迎回来，|おかえりなさい、|다시 오신 것을 환영합니다, |مرحبًا بعودتك، |Chào mừng trở lại, |Witaj ponownie, |Welkom terug, |З поверненням, |वापसी पर स्वागत है, ", true)
	D("Sobre|About|Acerca de|À propos|Info|Info|О программе|Hakkında|Tentang|关于|情報|정보|حول|Giới thiệu|O hubie|Over|Про хаб|परिचय")
	D("Painel|Home|Inicio|Accueil|Start|Home|Главная|Ana Sayfa|Beranda|主页|ホーム|홈|الرئيسية|Trang chủ|Start|Home|Головна|होम")
	D("Frutas|Fruits|Frutas|Fruits|Früchte|Frutti|Фрукты|Meyveler|Buah|水果|フルーツ|과일|الفواكه|Trái cây|Owoce|Fruit|Фрукти|फल")
	D("Teleporte|Teleport|Teletransporte|Téléportation|Teleport|Teletrasporto|Телепорт|Işınlanma|Teleportasi|传送|テレポート|텔레포트|الانتقال|Dịch chuyển|Teleport|Teleport|Телепорт|टेलीपोर्ट")
	D("Inventário|Inventory|Inventario|Inventaire|Inventar|Inventario|Инвентарь|Envanter|Inventaris|背包|インベントリ|인벤토리|المخزون|Kho đồ|Ekwipunek|Inventaris|Інвентар|इन्वेंटरी")
	D("Configurações|Settings|Ajustes|Réglages|Einstellungen|Impostazioni|Настройки|Ayarlar|Pengaturan|设置|設定|설정|الإعدادات|Cài đặt|Ustawienia|Instellingen|Налаштування|सेटिंग्स")
	D("Combate|Combat|Combate|Combat|Kampf|Combattimento|Бой|Savaş|Pertempuran|战斗|戦闘|전투|القتال|Chiến đấu|Walka|Gevecht|Бій|युद्ध")
	D("Rápido|Quick|Rápido|Rapide|Schnell|Rapido|Быстрый|Hızlı|Cepat|快捷|クイック|빠른 실행|سريع|Nhanh|Szybkie|Snel|Швидкий|त्वरित")
	D("Ativos|Active|Activos|Actifs|Aktiv|Attivi|Активные|Aktif|Aktif|已启用|有効|활성|النشطة|Đang bật|Aktywne|Actief|Активні|सक्रिय")
	D("Perfil|Profile|Perfil|Profil|Profil|Profilo|Профиль|Profil|Profil|个人资料|プロフィール|프로필|الملف الشخصي|Hồ sơ|Profil|Profiel|Профіль|प्रोफ़ाइल")
	D("Aparência|Appearance|Apariencia|Apparence|Aussehen|Aspetto|Внешний вид|Görünüm|Tampilan|外观|外観|모양|المظهر|Giao diện|Wygląd|Uiterlijk|Вигляд|रूप")
	D("Jogador|Player|Jugador|Joueur|Spieler|Giocatore|Игрок|Oyuncu|Pemain|玩家|プレイヤー|플레이어|اللاعب|Người chơi|Gracz|Speler|Гравець|खिलाड़ी")
	D("Personagem|Character|Personaje|Personnage|Charakter|Personaggio|Персонаж|Karakter|Karakter|角色|キャラクター|캐릭터|الشخصية|Nhân vật|Postać|Personage|Персонаж|किरदार")
	D("Tudo o que você precisa, ao seu alcance.|Everything you need, within reach.|Todo lo que necesitas, a tu alcance.|Tout ce dont vous avez besoin, à portée de main.|Alles, was du brauchst, in Reichweite.|Tutto ciò che ti serve, a portata di mano.|Всё необходимое — под рукой.|İhtiyacın olan her şey, elinin altında.|Semua yang kamu butuhkan, dalam jangkauan.|你所需的一切，触手可及。|必要なものがすべて、すぐそばに。|필요한 모든 것이 손끝에.|كل ما تحتاجه في متناول يدك.|Mọi thứ bạn cần, trong tầm tay.|Wszystko, czego potrzebujesz, w zasięgu ręki.|Alles wat je nodig hebt, binnen handbereik.|Усе потрібне — під рукою.|आपकी ज़रूरत की हर चीज़, आपकी पहुँच में।")
	D("Preferências de UI  ›|UI preferences  ›|Preferencias de UI  ›|Préférences d'UI  ›|UI-Einstellungen  ›|Preferenze UI  ›|Настройки UI  ›|Arayüz tercihleri  ›|Preferensi UI  ›|界面偏好  ›|UI設定  ›|UI 설정  ›|تفضيلات الواجهة  ›|Tùy chọn giao diện  ›|Ustawienia UI  ›|UI-voorkeuren  ›|Налаштування UI  ›|UI प्राथमिकताएँ  ›")
	D("Personalizar|Customize|Personalizar|Personnaliser|Anpassen|Personalizza|Настроить|Özelleştir|Kustomisasi|自定义|カスタマイズ|사용자 지정|تخصيص|Tùy chỉnh|Dostosuj|Aanpassen|Налаштувати|अनुकूलित करें")
	D("SESSÃO|SESSION|SESIÓN|SESSION|SITZUNG|SESSIONE|СЕССИЯ|OTURUM|SESI|会话|セッション|세션|الجلسة|PHIÊN|SESJA|SESSIE|СЕСІЯ|सत्र")
	D("JOGO ATUAL|CURRENT GAME|JUEGO ACTUAL|JEU ACTUEL|AKTUELLES SPIEL|GIOCO ATTUALE|ТЕКУЩАЯ ИГРА|MEVCUT OYUN|GAME SAAT INI|当前游戏|現在のゲーム|현재 게임|اللعبة الحالية|GAME HIỆN TẠI|OBECNA GRA|HUIDIGE GAME|ПОТОЧНА ГРА|वर्तमान गेम")
	D("Seu espaço|Your space|Tu espacio|Votre espace|Dein Bereich|Il tuo spazio|Ваше пространство|Alanın|Ruangmu|你的空间|あなたのスペース|내 공간|مساحتك|Không gian của bạn|Twoja przestrzeń|Jouw ruimte|Ваш простір|आपका स्थान")
	D("Novidades|What's new|Novedades|Nouveautés|Neuigkeiten|Novità|Что нового|Yenilikler|Yang baru|新内容|新機能|새 소식|الجديد|Có gì mới|Co nowego|Nieuw|Що нового|नया क्या है")
	D("Ocultar meu nome|Hide my name|Ocultar mi nombre|Masquer mon nom|Meinen Namen verbergen|Nascondi il mio nome|Скрыть моё имя|Adımı gizle|Sembunyikan namaku|隐藏我的名字|名前を隠す|내 이름 숨기기|إخفاء اسمي|Ẩn tên của tôi|Ukryj moją nazwę|Mijn naam verbergen|Сховати моє ім'я|मेरा नाम छिपाएँ")
	D("Reduzir movimento|Reduced motion|Reducir movimiento|Réduire les animations|Weniger Bewegung|Riduci movimento|Меньше анимации|Hareketi azalt|Kurangi gerakan|减少动画|モーションを減らす|모션 줄이기|تقليل الحركة|Giảm chuyển động|Ogranicz ruch|Minder beweging|Менше анімації|गति कम करें")
	D("Material de vidro|Glass material|Material de vidrio|Effet verre|Glasmaterial|Materiale vetro|Стекло|Cam efekti|Bahan kaca|玻璃材质|ガラス素材|유리 재질|مادة زجاجية|Chất liệu kính|Efekt szkła|Glasmateriaal|Скло|ग्लास सामग्री")
	D("Cor de destaque|Accent color|Color de acento|Couleur d'accent|Akzentfarbe|Colore principale|Цвет акцента|Vurgu rengi|Warna aksen|强调色|アクセントカラー|강조 색상|لون التمييز|Màu nhấn|Kolor akcentu|Accentkleur|Колір акценту|एक्सेंट रंग")
	D("Fonte|Font|Fuente|Police|Schriftart|Carattere|Шрифт|Yazı tipi|Font|字体|フォント|글꼴|الخط|Phông chữ|Czcionka|Lettertype|Шрифт|फ़ॉन्ट")
	D("Tamanho do painel|Panel size|Tamaño del panel|Taille du panneau|Panelgröße|Dimensione pannello|Размер панели|Panel boyutu|Ukuran panel|面板大小|パネルサイズ|패널 크기|حجم اللوحة|Kích thước bảng|Rozmiar panelu|Paneelgrootte|Розмір панелі|पैनल आकार")
	D("Idioma|Language|Idioma|Langue|Sprache|Lingua|Язык|Dil|Bahasa|语言|言語|언어|اللغة|Ngôn ngữ|Język|Taal|Мова|भाषा")
	D("Salvar configurações|Save settings|Guardar ajustes|Enregistrer les réglages|Einstellungen speichern|Salva impostazioni|Сохранить настройки|Ayarları kaydet|Simpan pengaturan|保存设置|設定を保存|설정 저장|حفظ الإعدادات|Lưu cài đặt|Zapisz ustawienia|Instellingen opslaan|Зберегти налаштування|सेटिंग्स सहेजें")
	D("Descarregar hub|Unload hub|Descargar hub|Décharger le hub|Hub entladen|Scarica hub|Выгрузить хаб|Hub'ı kapat|Tutup hub|卸载脚本|ハブを終了|허브 종료|إغلاق الهب|Tắt hub|Wyładuj hub|Hub afsluiten|Вивантажити хаб|हब बंद करें")
	D("Atualizar|Refresh|Actualizar|Actualiser|Aktualisieren|Aggiorna|Обновить|Yenile|Segarkan|刷新|更新|새로고침|تحديث|Làm mới|Odśwież|Vernieuwen|Оновити|ताज़ा करें")
	D("Visual|Visual|Visual|Visuel|Optik|Visivo|Визуал|Görsel|Visual|视觉|ビジュアル|비주얼|المرئيات|Hình ảnh|Wizualne|Visueel|Візуал|दृश्य")
	D("Farm|Farm|Farm|Farm|Farm|Farm|Фарм|Farm|Farm|刷怪|ファーム|파밍|فارم|Farm|Farm|Farm|Фарм|फार्म")
	D("Coleta|Collection|Recolección|Collecte|Sammeln|Raccolta|Сбор|Toplama|Pengumpulan|采集|収集|수집|الجمع|Thu thập|Zbieranie|Verzamelen|Збір|संग्रह")
	D("Haki e status|Haki & stats|Haki y estadísticas|Haki et stats|Haki & Werte|Haki e statistiche|Haki и статы|Haki ve statlar|Haki & status|霸气与属性|覇気とステータス|패기 및 스탯|الهاكي والإحصاءات|Haki & chỉ số|Haki i statystyki|Haki & stats|Хакі та статистика|हाकी और स्टैट्स")
	D("Códigos|Codes|Códigos|Codes|Codes|Codici|Коды|Kodlar|Kode|兑换码|コード|코드|الأكواد|Mã code|Kody|Codes|Коди|कोड")
	D("Loja do Dealer|Dealer shop|Tienda del Dealer|Boutique du Dealer|Dealer-Shop|Negozio del Dealer|Магазин Дилера|Satıcı mağazası|Toko Dealer|商人商店|ディーラーのショップ|딜러 상점|متجر التاجر|Cửa hàng Dealer|Sklep Dealera|Dealer-winkel|Магазин Дилера|डीलर की दुकान")
	D("Lista de desejos|Wish list|Lista de deseos|Liste de souhaits|Wunschliste|Lista dei desideri|Список желаний|İstek listesi|Daftar keinginan|愿望清单|ウィッシュリスト|위시리스트|قائمة الأمنيات|Danh sách mong muốn|Lista życzeń|Verlanglijst|Список бажань|इच्छा सूची")
	D("Histórico de frutas|Fruit history|Historial de frutas|Historique des fruits|Fruchtverlauf|Cronologia frutti|История фруктов|Meyve geçmişi|Riwayat buah|水果记录|フルーツ履歴|과일 기록|سجل الفواكه|Lịch sử trái cây|Historia owoców|Fruitgeschiedenis|Історія фруктів|फल इतिहास")
	D("Movimento|Movement|Movimiento|Mouvement|Bewegung|Movimento|Движение|Hareket|Gerakan|移动|移動|이동|الحركة|Di chuyển|Ruch|Beweging|Рух|चाल")
	D("Voar|Fly|Volar|Voler|Fliegen|Vola|Полёт|Uç|Terbang|飞行|飛行|비행|الطيران|Bay|Latanie|Vliegen|Політ|उड़ना")
	D("Pulo infinito|Infinite jump|Salto infinito|Saut infini|Unendlicher Sprung|Salto infinito|Бесконечный прыжок|Sonsuz zıplama|Lompat tak terbatas|无限跳|無限ジャンプ|무한 점프|قفز لا نهائي|Nhảy vô hạn|Nieskończony skok|Oneindig springen|Нескінченний стрибок|अनंत कूद")
	D("Velocidade|Speed|Velocidad|Vitesse|Geschwindigkeit|Velocità|Скорость|Hız|Kecepatan|速度|速度|속도|السرعة|Tốc độ|Prędkość|Snelheid|Швидкість|रफ़्तार")
	D("Gravidade|Gravity|Gravedad|Gravité|Schwerkraft|Gravità|Гравитация|Yerçekimi|Gravitasi|重力|重力|중력|الجاذبية|Trọng lực|Grawitacja|Zwaartekracht|Гравітація|गुरुत्वाकर्षण")
	D("Campo de visão|Field of view|Campo de visión|Champ de vision|Sichtfeld|Campo visivo|Поле зрения|Görüş alanı|Bidang pandang|视野|視野角|시야각|مجال الرؤية|Trường nhìn|Pole widzenia|Gezichtsveld|Поле зору|दृश्य क्षेत्र")
	D("Remover neblina|Remove fog|Quitar niebla|Supprimer le brouillard|Nebel entfernen|Rimuovi nebbia|Убрать туман|Sisi kaldır|Hapus kabut|去除雾气|霧を消す|안개 제거|إزالة الضباب|Xóa sương mù|Usuń mgłę|Mist verwijderen|Прибрати туман|कोहरा हटाएँ")
	D("Auto baús|Auto chests|Auto cofres|Auto coffres|Auto-Truhen|Auto forzieri|Авто-сундуки|Otomatik sandık|Auto peti|自动宝箱|自動チェスト|자동 상자|صناديق تلقائية|Tự nhặt rương|Auto skrzynie|Auto kisten|Авто-скрині|ऑटो संदूक")
	D("Auto pegar frutas|Auto collect fruits|Auto recoger frutas|Auto ramasser fruits|Auto-Früchte sammeln|Auto raccogli frutti|Авто-сбор фруктов|Otomatik meyve topla|Auto ambil buah|自动拾取水果|自動フルーツ回収|자동 과일 줍기|جمع الفواكه تلقائيًا|Tự nhặt trái cây|Auto zbieranie owoców|Auto fruit pakken|Авто-збір фруктів|ऑटो फल उठाएँ")
	D("Puxar mobs|Bring mobs|Atraer mobs|Attirer les monstres|Mobs heranziehen|Attira i mob|Притягивать мобов|Canavarları çek|Tarik mob|聚怪|モブを引き寄せる|몹 끌어오기|سحب الوحوش|Kéo quái|Przyciągaj moby|Mobs aantrekken|Притягувати мобів|मॉब खींचें")
	D("Modo seguro|Safe mode|Modo seguro|Mode sûr|Sicherer Modus|Modalità sicura|Безопасный режим|Güvenli mod|Mode aman|安全模式|セーフモード|안전 모드|الوضع الآمن|Chế độ an toàn|Tryb bezpieczny|Veilige modus|Безпечний режим|सुरक्षित मोड")
	D("Skills automáticas|Auto skills|Habilidades automáticas|Compétences automatiques|Automatische Fähigkeiten|Abilità automatiche|Авто-скиллы|Otomatik yetenekler|Skill otomatis|自动技能|自動スキル|자동 스킬|مهارات تلقائية|Kỹ năng tự động|Auto umiejętności|Auto skills|Авто-вміння|ऑटो स्किल")
	D("Desligar tudo|Turn everything off|Apagar todo|Tout éteindre|Alles ausschalten|Spegni tutto|Выключить всё|Hepsini kapat|Matikan semua|全部关闭|すべてオフ|모두 끄기|إيقاف الكل|Tắt tất cả|Wyłącz wszystko|Alles uitzetten|Вимкнути все|सब बंद करें")
	D("Nenhuma função ativa.|No active feature.|Ninguna función activa.|Aucune fonction active.|Keine aktive Funktion.|Nessuna funzione attiva.|Нет активных функций.|Aktif işlev yok.|Tidak ada fitur aktif.|没有已启用的功能。|有効な機能はありません。|활성 기능 없음.|لا توجد وظائف نشطة.|Không có chức năng nào đang bật.|Brak aktywnych funkcji.|Geen actieve functie.|Немає активних функцій.|कोई सक्रिय फ़ंक्शन नहीं।")
	D("Presets|Presets|Ajustes rápidos|Préréglages|Voreinstellungen|Preset|Пресеты|Hazır ayarlar|Preset|预设|プリセット|프리셋|إعدادات مسبقة|Cài sẵn|Presety|Presets|Пресети|प्रीसेट")
	D("Favoritos|Favorites|Favoritos|Favoris|Favoriten|Preferiti|Избранное|Favoriler|Favorit|收藏|お気に入り|즐겨찾기|المفضلة|Yêu thích|Ulubione|Favorieten|Обране|पसंदीदा")
	D("Densidade|Density|Densidad|Densité|Dichte|Densità|Плотность|Yoğunluk|Kepadatan|密度|密度|밀도|الكثافة|Mật độ|Gęstość|Dichtheid|Щільність|घनत्व")
	D("Modo foco|Focus mode|Modo enfoque|Mode focus|Fokusmodus|Modalità focus|Режим фокуса|Odak modu|Mode fokus|专注模式|フォーカスモード|집중 모드|وضع التركيز|Chế độ tập trung|Tryb skupienia|Focusmodus|Режим фокусу|फ़ोकस मोड")
	D("Barra lateral compacta|Compact sidebar|Barra lateral compacta|Barre latérale compacte|Kompakte Seitenleiste|Barra laterale compatta|Компактная панель|Kompakt kenar çubuğu|Sidebar ringkas|紧凑侧边栏|コンパクトサイドバー|간단한 사이드바|شريط جانبي مضغوط|Thanh bên gọn|Kompaktowy pasek boczny|Compacte zijbalk|Компактна бічна панель|कॉम्पैक्ट साइडबार")
	D("Sons da interface|Interface sounds|Sonidos de la interfaz|Sons de l'interface|Oberflächensounds|Suoni dell'interfaccia|Звуки интерфейса|Arayüz sesleri|Suara antarmuka|界面音效|UIサウンド|인터페이스 소리|أصوات الواجهة|Âm thanh giao diện|Dźwięki interfejsu|Interfacegeluiden|Звуки інтерфейсу|इंटरफ़ेस ध्वनियाँ")
	D("Ordem das abas|Tab order|Orden de pestañas|Ordre des onglets|Tab-Reihenfolge|Ordine schede|Порядок вкладок|Sekme sırası|Urutan tab|标签顺序|タブの順序|탭 순서|ترتيب التبويبات|Thứ tự tab|Kolejność kart|Tabvolgorde|Порядок вкладок|टैब क्रम")
	D("Dados|Data|Datos|Données|Daten|Dati|Данные|Veri|Data|数据|データ|데이터|البيانات|Dữ liệu|Dane|Gegevens|Дані|डेटा")
	D("Tema|Theme|Tema|Thème|Design|Tema|Тема|Tema|Tema|主题|テーマ|테마|السمة|Chủ đề|Motyw|Thema|Тема|थीम")

	-- motor de tradução ao vivo
	local recs, idx = setmetatable({}, {__mode = "k"}), 1
	local function resolve(text)
		if type(text) ~= "string" or text == "" then return end
		local pre, core = text:match("^(%s*)(.-)$")
		local arr = REV[core:lower()]
		if arr then return arr, pre, "" end
		for _, a in ipairs(PFX) do
			for _, s in ipairs(a) do
				if #s > 0 and core:sub(1, #s) == s then return a, pre, core:sub(#s + 1) end
			end
		end
		local ic, rest = core:match("^([^%w%s]+%s+)(.+)$")
		if rest then
			arr = REV[rest:lower()]
			if arr then return arr, pre .. ic, "" end
		end
	end
	local function propOf(i)
		if i:IsA("TextBox") then return "PlaceholderText" end
		if i:IsA("TextLabel") or i:IsA("TextButton") then return "Text" end
	end
	local function apply(i, r)
		local want = r.pre .. (r.arr[idx] or r.arr[2] or r.arr[1]) .. r.suf
		if i[r.p] ~= want then
			r.set = true
			r.x = want
			i[r.p] = want
			r.set = false
		end
	end
	local function hook(i)
		if recs[i] then return end
		local p = propOf(i)
		if not p then return end
		local arr, pre, suf = resolve(i[p])
		if not arr then return end
		local r = {p = p, arr = arr, pre = pre, suf = suf}
		recs[i] = r
		i:GetPropertyChangedSignal(p):Connect(function()
			if r.set then return end
			local v = i[p]
			if v == r.x then return end
			local a2, p2, s2 = resolve(v)
			if a2 then
				r.arr, r.pre, r.suf = a2, p2, s2
				apply(i, r)
			else
				r.arr = nil
			end
		end)
		apply(i, r)
	end
	AHX.rescan = function()
		for _, d in ipairs(gui:GetDescendants()) do pcall(hook, d) end
		for i, r in pairs(recs) do if r.arr then pcall(apply, i, r) end end
	end
	AHX.setLang = function(code, silent)
		local n = LI[code]
		if not n then return end
		idx = n
		S.Lang = code
		S.LangName = LN[n]
		for i, r in pairs(recs) do if r.arr then pcall(apply, i, r) end end
		syncAll()
		if not silent then toast("✦", LN[n], 2) end
	end
	track(gui.DescendantAdded:Connect(function(d) task.defer(function() pcall(hook, d) end) end))
	idx = LI[S.Lang] or (lang == "pt" and 1 or 2)
	S.LangName = LN[idx]
	AHX.rescan()
	GM.loop(1, function() if LI[S.Lang] and LI[S.Lang] ~= idx then AHX.setLang(S.Lang, true) end end)
end)()

-- executa um bloco protegido (erros viram aviso no console, sem derrubar o painel)
AHX.run = function(f)
	if AHX.fail then return end
	local ok, e = pcall(f)
	if not ok then warn("[Apple Blox] " .. tostring(e)) end
end

-- ===== FIM DA PARTE A · cole a PARTE B logo abaixo desta linha =====
-- ===== APPLE BLOX · PARTE B de 2 (cole logo ABAIXO da Parte A, no MESMO script) =====

------------------------------------------------------------------
-- B1) LIGAÇÕES (tema novo, acento, atalhos antigos)
------------------------------------------------------------------
AHX.run(function()
	pcall(function() local o = Lighting:FindFirstChild("AppleBloxBlur") if o then o:Destroy() end end)
	local oldShow = showPage
	showPage = function(id)
		if id == "cfg" then id = "settings" end
		return oldShow(id)
	end
	local oldSetAcc = setAccent
	setAccent = function(n) S.UseCustomAcc = false; oldSetAcc(n) end
	local oldApply = AHX.applyTheme
	AHX.applyTheme = function(name) oldApply(name); S.Accent = "Copper" end
	if S.PartType ~= "Runes" then S.Runes = false end
	bind(ucard, "BackgroundColor3", "card")
	bind(uav, "BackgroundColor3", "bg")
end)

------------------------------------------------------------------
-- B2) VISUAL: logo, header, layout, vidro, glow, toasts
------------------------------------------------------------------
AHX.run(function()
	local white = Color3.new(1, 1, 1)
	for _, c in ipairs(side:GetChildren()) do
		if c:IsA("TextLabel") then
			if c.Text == "✦" then c.Visible = false
			elseif c.Text == "APPLE HUB" then AHX.brand = c; c.Position = UDim2.fromOffset(44, 9); c.Size = UDim2.new(1, -50, 0, 16); c.TextSize = 12
			elseif c.Text == "Blox Fruits Edition" then AHX.sub = c; c.Position = UDim2.fromOffset(44, 26); c.Size = UDim2.new(1, -50, 0, 14); c.Text = "Blox Edition • v1.1" end
		end
	end
	-- maçã geométrica (corpo, mordida e folha)
	local logo = new("TextButton", {Size = UDim2.fromOffset(30, 30), Position = UDim2.fromOffset(8, 8), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 4, Parent = side})
	local body = new("Frame", {Size = UDim2.fromOffset(20, 20), Position = UDim2.fromOffset(5, 8), BackgroundColor3 = white, BorderSizePixel = 0, ZIndex = 4, Parent = logo}, {corner(10)})
	local bgrad = new("UIGradient", {Rotation = 60, Parent = body})
	local glowS = new("UIStroke", {Thickness = 1.5, Transparency = 0.55, Color = T.acc, Parent = body})
	local bite = new("Frame", {Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(17, 6), BorderSizePixel = 0, ZIndex = 5, Parent = logo}, {corner(5)})
	bind(bite, "BackgroundColor3", "side")
	local leaf = new("Frame", {Size = UDim2.fromOffset(9, 5), Position = UDim2.fromOffset(13, 2), Rotation = -35, BorderSizePixel = 0, ZIndex = 4, Parent = logo}, {corner(3)})
	local function paintLogo()
		bgrad.Color = ColorSequence.new(T.acc, T.acc:Lerp(white, 0.45))
		leaf.BackgroundColor3 = T.acc:Lerp(white, 0.25)
		glowS.Color = T.acc
	end
	paintLogo()
	repaints[#repaints + 1] = paintLogo
	-- easter egg: 7 toques na maçã
	local taps, lastTap = 0, 0
	logo.MouseButton1Click:Connect(function()
		if tick() - lastTap > 1.2 then taps = 0 end
		lastTap = tick(); taps = taps + 1
		if taps >= 7 then taps = 0; AHX.eggUntil = tick() + 8; toast("✦", "Easter egg!", 3) end
	end)
	GM.loop(0.2, function()
		if AHX.eggUntil and tick() < AHX.eggUntil then
			T.acc = Color3.fromHSV((tick() * 0.4) % 1, 0.6, 1)
			rebind()
			for _, f in ipairs(repaints) do pcall(f) end
			AHX.egged = true
		elseif AHX.egged then
			AHX.egged = false
			AHX.applyTheme(S.Theme)
		end
	end)
	-- badge de status e relógio no header
	local badge = new("Frame", {Size = UDim2.fromOffset(80, 20), Position = UDim2.new(1, -216, 0, 9), BorderSizePixel = 0, ZIndex = 6, Parent = top}, {corner(10)})
	bind(badge, "BackgroundColor3", "card"); stroke(badge, "line", 1)
	local dotB = new("Frame", {Size = UDim2.fromOffset(6, 6), Position = UDim2.fromOffset(8, 7), BorderSizePixel = 0, ZIndex = 7, Parent = badge}, {corner(3)})
	local badgeT = txt({Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(18, 0), Text = "Idle", TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 7, Parent = badge}, false)
	local clk = txt({Size = UDim2.fromOffset(66, 38), Position = UDim2.new(1, -132, 0, 0), Text = "", TextSize = 9, ZIndex = 6, Parent = top}, false, "sub")
	local STAT = {{"AutoLevel", "Auto Level"}, {"Farm", "Farming…"}, {"AutoBoss", "Boss Farm"}, {"AutoElite", "Elite"}, {"Sniper", "Sniper On"}, {"Chest", "Chests"}, {"FruitGrab", "Fruit Grab"}, {"Fly", "Flying"}}
	function AHX.status()
		local n, first = 0, nil
		for _, e in ipairs(STAT) do if S[e[1]] then n = n + 1; first = first or e[2] end end
		return first, n
	end
	GM.loop(0.5, function()
		local first, n = AHX.status()
		badgeT.Text = first and (first .. (n > 1 and (" +" .. (n - 1)) or "")) or "Idle"
		clk.Text = os.date("%H:%M") .. " " .. GM.fps .. "fps"
	end)
	-- vidro, blur e cartões com profundidade
	AHX.glass = function()
		local a = S.GlassAlpha / 100
		main.BackgroundTransparency = a
		side.BackgroundTransparency = math.clamp(a + 0.05, 0, 0.9)
		mainStroke.Transparency = math.clamp(0.45 - a * 0.4, 0.1, 0.6)
		for _, g in ipairs(groups) do
			g.f.BackgroundTransparency = math.clamp(a * 0.9 + 0.04, 0, 0.9)
			local st = g.f:FindFirstChildOfClass("UIStroke")
			if st then
				local gr = st:FindFirstChild("AH3D")
				if S.Cards3D and not gr then new("UIGradient", {Name = "AH3D", Rotation = 90, Transparency = NumberSequence.new(0.05, 0.75), Parent = st})
				elseif not S.Cards3D and gr then gr:Destroy() end
			end
		end
	end
	-- o dropdown antigo "Material de vidro" (tela Painel) continua funcionando
	AHX.lastGlass = S.Glass
	GM.loop(0.3, function()
		if S.Glass ~= AHX.lastGlass then
			AHX.lastGlass = S.Glass
			S.GlassAlpha = ({Off = 0, Soft = 5, Enhanced = 12})[S.Glass] or 12
			AHX.glass(); syncAll()
		end
	end)
	-- glow dinâmico: o painel pulsa na cor de destaque quando algo automático está ligado
	GM.loop(0.05, function()
		local first = AHX.status()
		if first and not S.ReducedMotion then
			local k = 0.5 + 0.5 * math.sin(tick() * 3)
			mainStroke.Color = T.acc; mainStroke.Transparency = 0.7 - 0.45 * k; mainStroke.Thickness = 1 + k
			dotB.BackgroundColor3 = Color3.fromRGB(95, 208, 140):Lerp(white, k * 0.25)
			AHX.wasActive = true
		else
			dotB.BackgroundColor3 = first and Color3.fromRGB(95, 208, 140) or T.sub
			if AHX.wasActive then
				AHX.wasActive = false
				mainStroke.Color = T.line; mainStroke.Thickness = 1
				AHX.glass()
			end
		end
	end)
	local blur = new("BlurEffect", {Name = "AppleBloxBlur", Size = 0, Parent = Lighting})
	GM.loop(0.3, function() tw(blur, 0.3, {Size = (S.Blur and shown) and S.BlurSize or 0}) end)
	gui.Destroying:Connect(function() pcall(function() blur:Destroy() end) end)
	-- botão do modo foco e layout (compacto / foco / densidade)
	local focusBtn = txt({Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, -38, 0, 8), Text = "↩", TextSize = 16, ZIndex = 30, Visible = false, AutoButtonColor = false, Parent = main}, true, "acc", "TextButton")
	focusBtn.MouseButton1Click:Connect(function() S.Focus = false; AHX.layout(); syncAll() end)
	AHX.layout = function()
		local sw = S.Focus and 0 or (S.Compact and 54 or 132)
		side.Visible, top.Visible = not S.Focus, not S.Focus
		side.Size = UDim2.new(0, sw, 1, 0)
		top.Size = UDim2.new(1, -sw, 0, 38); top.Position = UDim2.fromOffset(sw, 0)
		local ct = S.Focus and 0 or 38
		content.Position = UDim2.fromOffset(sw, ct); content.Size = UDim2.new(1, -sw, 1, -ct)
		pick.Position = UDim2.fromOffset(sw + 10, 38)
		for _, p in pairs(pages) do
			p.lb.Visible = not S.Compact
			p.ic.Position = S.Compact and UDim2.new(0.5, -10, 0, 0) or UDim2.fromOffset(10, 0)
			p.ic.TextSize = S.Compact and 19 or 17
		end
		if AHX.brand then AHX.brand.Visible = not S.Compact end
		if AHX.sub then AHX.sub.Visible = not S.Compact end
		logo.Position = S.Compact and UDim2.new(0.5, -15, 0, 8) or UDim2.fromOffset(8, 8)
		for _, c in ipairs(ucard:GetChildren()) do if c:IsA("TextLabel") then c.Visible = not S.Compact end end
		uav.Position = S.Compact and UDim2.new(0.5, -13, 0, 9) or UDim2.fromOffset(8, 9)
		focusBtn.Visible = S.Focus
		local pad = S.Density == "Compacto" and 4 or (S.Density == "Espaçoso" and 14 or 8)
		for _, p in pairs(pages) do
			local l = p.sc:FindFirstChildOfClass("UIListLayout")
			if l then l.Padding = UDim.new(0, pad) end
		end
	end
	-- neve suave só dentro do painel
	local snowL = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 0, ClipsDescendants = true, Visible = false, Parent = main})
	local snow = {}
	for i = 1, 26 do
		local f = new("Frame", {Size = UDim2.fromOffset(3, 3), BackgroundColor3 = white, BackgroundTransparency = 0.55, BorderSizePixel = 0, Parent = snowL}, {corner(2)})
		snow[i] = {f = f, x = math.random(), y = math.random(), v = 0.05 + math.random() * 0.08, ph = math.random() * 6}
	end
	track(RS.RenderStepped:Connect(function(dt)
		local on = S.PartType == "Neve" and shown
		snowL.Visible = on
		if not on then return end
		dt = math.min(dt, 0.05)
		local t = tick()
		for _, s in ipairs(snow) do
			s.y = s.y + s.v * dt
			if s.y > 1.03 then s.y = -0.03; s.x = math.random() end
			s.f.Position = UDim2.fromScale(s.x + math.sin(t + s.ph) * 0.01, s.y)
		end
	end))
	-- toasts dentro do painel, confirmação de save e háptico
	AHX.oldToast = toast
	local tbox = new("Frame", {Size = UDim2.new(0, 230, 0, 150), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 66, 1, -10), BackgroundTransparency = 1, ZIndex = 50, Parent = main},
		{new("UIListLayout", {Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Center})})
	toast = function(title, msg, dur)
		if not (S.ToastInside and shown) then return AHX.oldToast(title, msg, dur) end
		dur = dur or 3
		local kids = {}
		for _, c in ipairs(tbox:GetChildren()) do if c:IsA("CanvasGroup") then kids[#kids + 1] = c end end
		if #kids >= 3 then kids[1]:Destroy() end
		local f = new("CanvasGroup", {Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = T.card, GroupTransparency = 1, ZIndex = 51, LayoutOrder = math.floor(tick() * 10) % 1000000, Parent = tbox}, {corner(8)})
		bind(f, "BackgroundColor3", "card"); stroke(f, "acc", 1)
		txt({Size = UDim2.new(1, -16, 0, 16), Position = UDim2.fromOffset(10, 5), Text = tostring(title), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 52, Parent = f}, true)
		txt({Size = UDim2.new(1, -16, 0, 14), Position = UDim2.fromOffset(10, 21), Text = tostring(msg), TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 52, Parent = f}, false, "sub")
		local bar = new("Frame", {Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), BorderSizePixel = 0, ZIndex = 52, Parent = f})
		bind(bar, "BackgroundColor3", "acc")
		tw(f, 0.25, {GroupTransparency = 0})
		tw(bar, dur, {Size = UDim2.new(0, 0, 0, 2)}, Enum.EasingStyle.Linear)
		local hit = new("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 53, Parent = f})
		local function close()
			if f.Parent then tw(f, 0.25, {GroupTransparency = 1}); task.delay(0.3, function() pcall(function() f:Destroy() end) end) end
		end
		hit.MouseButton1Click:Connect(close)
		task.delay(dur, close)
	end
	AHX.saveCheck = function()
		if not S.SaveCheck then return end
		local f = new("Frame", {Size = UDim2.fromOffset(44, 44), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 46), BackgroundColor3 = Color3.fromRGB(80, 200, 120), BackgroundTransparency = 1, ZIndex = 60, Parent = main}, {corner(22)})
		local t = txt({Size = UDim2.fromScale(1, 1), Text = "✔", TextSize = 24, ZIndex = 61, Parent = f}, true, false)
		t.TextColor3 = white; t.TextTransparency = 1
		tw(f, 0.2, {BackgroundTransparency = 0.1}); tw(t, 0.2, {TextTransparency = 0})
		task.delay(1.1, function()
			tw(f, 0.3, {BackgroundTransparency = 1}); tw(t, 0.3, {TextTransparency = 1})
			task.wait(0.35)
			pcall(function() f:Destroy() end)
		end)
	end
	local HapS = game:GetService("HapticService")
	local oldClick = click
	click = function()
		oldClick()
		if S.Haptic then
			pcall(function()
				HapS:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0.5)
				task.delay(0.05, function() pcall(function() HapS:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small, 0) end) end)
			end)
		end
	end
	-- ações rápidas no cartão do usuário
	local qa = new("Frame", {Size = UDim2.fromOffset(150, 0), AutomaticSize = Enum.AutomaticSize.Y, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 8, 1, -56), Visible = false, ZIndex = 40, Parent = main},
		{corner(8), new("UIListLayout", {Padding = UDim.new(0, 3)}), new("UIPadding", {PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})})
	bind(qa, "BackgroundColor3", "card"); stroke(qa, "acc", 1)
	local function qbtn(text, cb)
		local b = txt({Size = UDim2.new(1, 0, 0, 24), Text = text, TextSize = 10, AutoButtonColor = false, ZIndex = 41, Parent = qa}, false, "text", "TextButton")
		b.MouseButton1Click:Connect(function() click(); qa.Visible = false; task.spawn(function() pcall(cb) end) end)
	end
	qbtn("Reentrar no servidor", function() TPS:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp) end)
	qbtn("Trocar de servidor", function() GM.hop() end)
	qbtn("Copiar Job ID", function() pcall(function() setclipboard(game.JobId) end) toast("Job ID", "OK", 2) end)
	qbtn("Copiar meu nome", function() pcall(function() setclipboard(lp.Name) end) toast(lp.Name, "OK", 2) end)
	qbtn("Resetar personagem", function() local h = GM.hum() if h then h.Health = 0 end end)
	qbtn("Modo foco", function() S.Focus = not S.Focus; AHX.layout(); syncAll() end)
	ucard.MouseButton1Click:Connect(function() click(); qa.Visible = not qa.Visible end)
end)

------------------------------------------------------------------
-- B3) ABAS ORGANIZADAS (Farm, Combate, Frutas, ESP, Jogador, Visual, Rápido, Ativos)
------------------------------------------------------------------
AHX.run(function()
	AHX.feat, AHX.featOrder, AHX.isVisible = {}, {}, {}
	local function setFeat(k, v)
		S[k] = v
		local f = AHX.feat[k]
		if f and f.cb then pcall(f.cb, v) end
	end
	AHX.setFeat = setFeat
	AHX.LONG = {
		AutoBoss = {"Boss", GM.Bosses, function(v) S.Boss = v end},
		AutoStats = {"Status", {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"}, function(v) S.Stat = v end},
		AutoEquip = {"Arma", {"Melee", "Sword", "Gun", "Blox Fruit"}, function(v) S.Weapon = v end},
		Skills = {"Skills", {"Z,X", "Z,X,C", "Z,X,C,V", "Z,X,C,V,F"}, function(v) S.SkillKeys = v end},
		Fly = {"Fly", {"40", "80", "120", "200"}, function(v) S.FlySpeed = tonumber(v) end},
		SpeedOn = {"Velocidade", {"30", "60", "100", "150"}, function(v) S.Speed = tonumber(v) end},
		Sniper = {"Sniper (s)", {"6", "12", "30", "60"}, function(v) S.SniperWait = tonumber(v) end},
		Bring = {"Puxar mobs", {"150", "300", "450", "600"}, function(v) S.BringR = tonumber(v) end},
		Safe = {"Modo seguro (%)", {"20", "30", "50", "70"}, function(v) S.SafePct = tonumber(v) end},
	}
	AHX.longMenu = function(key)
		local cfg = AHX.LONG[key]
		if not cfg then return end
		local back = new("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.45, Text = "", AutoButtonColor = false, ZIndex = 44, Parent = main})
		local box = new("Frame", {Size = UDim2.fromOffset(210, 0), AutomaticSize = Enum.AutomaticSize.Y, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), ZIndex = 45, Parent = back},
			{corner(8), new("UIListLayout", {Padding = UDim.new(0, 4)}), new("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})})
		bind(box, "BackgroundColor3", "card"); stroke(box, "acc", 1.5)
		txt({Size = UDim2.new(1, 0, 0, 20), Text = tostring(cfg[1]), TextSize = 12, ZIndex = 46, LayoutOrder = 0, Parent = box}, true, "acc")
		local sc = new("ScrollingFrame", {Size = UDim2.new(1, 0, 0, math.min(#cfg[2] * 30, 150)), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
			AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ZIndex = 46, LayoutOrder = 1, Parent = box}, {new("UIListLayout", {Padding = UDim.new(0, 3)})})
		for _, o in ipairs(cfg[2]) do
			local b = txt({Size = UDim2.new(1, -4, 0, 27), Text = o, TextSize = 10, AutoButtonColor = false, ZIndex = 47, Parent = sc}, false, "text", "TextButton")
			bind(b, "BackgroundColor3", "bg"); b.BackgroundTransparency = 0
			new("UICorner", {CornerRadius = UDim.new(0, 5), Parent = b})
			b.MouseButton1Click:Connect(function() click(); cfg[3](o); syncAll(); toast(cfg[1], o, 2); back:Destroy() end)
		end
		back.MouseButton1Click:Connect(function() back:Destroy() end)
	end
	-- toggle com ☆ de favorito, toque no texto e toque longo (0,6 s)
	AHX.tog = function(g, text, key, cb, sub)
		toggle(g, text, key, cb, sub)
		if not AHX.feat[key] then AHX.feat[key] = {text = text, cb = cb}; AHX.featOrder[#AHX.featOrder + 1] = key end
		local r = g.rows[#g.rows] and g.rows[#g.rows].f
		if not r then return end
		for _, l in ipairs(r:GetChildren()) do
			if l:IsA("TextLabel") then l.Size = UDim2.new(1, -108, l.Size.Y.Scale, l.Size.Y.Offset) end
		end
		local star = txt({Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -80, 0.5, -12), Text = S.Fav[key] and "★" or "☆", TextSize = 15, ZIndex = 3, AutoButtonColor = false, Parent = r}, false, "acc", "TextButton")
		star.MouseButton1Click:Connect(function()
			S.Fav[key] = (not S.Fav[key]) or nil
			star.Text = S.Fav[key] and "★" or "☆"
			if AHX.rebuildQuick then AHX.rebuildQuick() end
		end)
		local hit = new("TextButton", {Size = UDim2.new(1, -110, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 2, Parent = r})
		local down, tok, fired = false, 0, false
		hit.InputBegan:Connect(function(i)
			if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
			down, tok = true, tok + 1
			local my = tok
			if S.LongPress and AHX.LONG[key] then
				task.delay(0.6, function() if down and tok == my then fired = true; click(); AHX.longMenu(key) end end)
			end
		end)
		hit.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then down = false end
		end)
		hit.MouseButton1Click:Connect(function()
			if fired then fired = false return end
			click(); setFeat(key, not S[key]); syncAll()
		end)
	end
	local tog = AHX.tog

	local function mk(id, label, icon) AHX.isVisible[id] = true return addPage(id, label, icon) end
	local pF, pC, pFr, pE, pP, pV = mk("farm", "Farm", "⚔"), mk("combat", "Combate", "✧"), mk("fruits2", "Frutas", "❖"), mk("esp2", "ESP", "◉"), mk("player", "Jogador", "☻"), mk("visual", "Visual", "◐")
	local pQ, pA, pS = mk("quick", "Rápido", "★"), mk("active", "Ativos", "●"), mk("settings", "Configurações", "✦")
	for _, id in ipairs({"home", "tp", "inv", "wh", "about"}) do AHX.isVisible[id] = true end

	-- FARM
	section(pF, "Auto Level")
	local g = group(pF, "farm")
	tog(g, "Auto Level + Quest", "AutoLevel", nil, "Quests automáticas por nível")
	info(g, "Quest", function() local e = GM.questFor(GM.val("Level") or 1) return e and e.mob or "—" end)
	slider(g, "Velocidade de viagem", 100, 600, "TravelSpeed", nil, " st/s")
	slider(g, "Altura sobre o mob", 4, 25, "Height", nil, " st")
	section(pF, "Farm")
	g = group(pF, "farm")
	tog(g, "Auto Farm (mob mais próximo)", "Farm")
	tog(g, "Puxar mobs", "Bring")
	slider(g, "Raio de puxar", 100, 600, "BringR", nil, " st")
	tog(g, "Modo seguro", "Safe", nil, "Sobe se o HP ficar baixo")
	slider(g, "HP mínimo", 10, 70, "SafePct", nil, "%")
	section(pF, "Boss & Elite")
	g = group(pF, "farm")
	dropdown(g, "Boss", GM.Bosses, "Boss")
	tog(g, "Auto Boss", "AutoBoss")
	tog(g, "Auto Elite Hunter", "AutoElite")
	section(pF, "Coleta")
	g = group(pF, "farm")
	tog(g, "Auto baús", "Chest")
	tog(g, "Auto pegar frutas", "FruitGrab")
	section(pF, "Timer de farm")
	g = group(pF, "farm")
	AHX.farmSecs = 0
	info(g, "Tempo de farm", function() return GM.clock(AHX.farmSecs) end)
	info(g, "Beli / h", function() return GM.fmt(GM.rate("Beli")) end)
	button(g, "Zerar timer", function() AHX.farmSecs = 0 end)
	GM.loop(1, function() if S.AutoLevel or S.Farm or S.AutoBoss or S.AutoElite then AHX.farmSecs = AHX.farmSecs + 1 end end)

	-- COMBATE
	section(pC, "Combate")
	g = group(pC, "combat")
	dropdown(g, "Arma", {"Melee", "Sword", "Gun", "Blox Fruit"}, "Weapon")
	tog(g, "Equipar arma automaticamente", "AutoEquip")
	tog(g, "Auto Click rápido", "Click")
	slider(g, "Delay do ataque", 20, 500, "ClickDelay", nil, " ms")
	tog(g, "Skills automáticas", "Skills")
	input(g, "Teclas das skills (ex: Z,X,C)", "Z,X", function(t) S.SkillKeys = t; toast("Skills", t, 2) end)
	slider(g, "Intervalo das skills", 200, 3000, "SkillDelay", nil, " ms")
	section(pC, "Haki e status")
	g = group(pC, "combat")
	tog(g, "Auto Buso Haki", "Buso")
	tog(g, "Auto Ken Haki", "Ken")
	tog(g, "Auto Status", "AutoStats")
	dropdown(g, "Status", {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"}, "Stat")
	slider(g, "Pontos por vez", 1, 10, "StatPts")
	section(pC, "Códigos")
	g = group(pC, "combat")
	tog(g, "Resgatar códigos ao iniciar", "AutoCodes")
	button(g, "Resgatar todos agora", function() GM.redeemAll() end, true)
	input(g, "Adicionar código", "ABC123", function(c) GM.addCode(c) end)
	UI.codeLog = para(g, "O resultado dos códigos aparece aqui.")

	-- FRUTAS
	section(pFr, "Loja do Dealer")
	g = group(pFr, "fruits2")
	button(g, "Atualizar estoque", function() GM.refreshShop() end, true)
	UI.shopG = group(pFr, "fruits2")
	rowItem(UI.shopG, "Toque em atualizar estoque.", {})
	section(pFr, "Lista de desejos")
	g = group(pFr, "fruits2")
	input(g, "Frutas desejadas (ex: leopard,kitsune)", "leopard,kitsune", function(t) S.Wish = t; toast("Loja", t, 2.5) end)
	info(g, "Lista atual", function() return S.Wish end)
	tog(g, "Comprar sozinho se tiver Beli", "AutoBuy", nil, "Verifica a cada 45 s")
	section(pFr, "Coleta")
	g = group(pFr, "fruits2")
	tog(g, "Auto pegar frutas", "FruitGrab")
	tog(g, "Auto guardar no inventário", "AutoStore")
	tog(g, "Avisar quando fruta nascer", "FruitNotify")
	tog(g, "Fruit Sniper", "Sniper", nil, "Troca de servidor até achar fruta")
	slider(g, "Esperar antes de trocar", 5, 90, "SniperWait", nil, " s")
	info(g, "Status do sniper", function() return GM.sniperStatus or "—" end)
	section(pFr, "Histórico de frutas")
	local histG = group(pFr, "fruits2")
	AHX.hist = {}
	local function refreshHist()
		clearGroup(histG)
		if #AHX.hist == 0 then rowItem(histG, "Nenhuma fruta detectada ainda.", {}) return end
		for _, h in ipairs(AHX.hist) do rowItem(histG, h.t .. "  •  " .. h.n, {}) end
	end
	refreshHist()
	local lastF
	GM.loop(2, function()
		local f = GM.fruit()
		if f and f ~= lastF then
			lastF = f
			table.insert(AHX.hist, 1, {n = f.Name, t = os.date("%H:%M")})
			while #AHX.hist > 10 do table.remove(AHX.hist) end
			refreshHist()
		elseif not f then lastF = nil end
	end)

	-- ESP
	section(pE, "ESP")
	g = group(pE, "esp2")
	tog(g, "Jogadores", "EspPlayers", nil, "Nome, distância e vida")
	tog(g, "Frutas", "EspFruits")
	tog(g, "Baús", "EspChests")
	tog(g, "Bosses", "EspBosses")

	-- JOGADOR
	section(pP, "Movimento")
	g = group(pP, "player")
	tog(g, "Velocidade personalizada", "SpeedOn", function(v) if not v then local h = GM.hum() if h then h.WalkSpeed = 16 end end end)
	slider(g, "Velocidade", 16, 200, "Speed")
	tog(g, "Pulo personalizado", "JumpOn", function(v) if not v then local h = GM.hum() if h then h.JumpPower = 50 end end end)
	slider(g, "Força do pulo", 50, 300, "Jump")
	tog(g, "Voar", "Fly")
	slider(g, "Velocidade do voo", 20, 200, "FlySpeed")
	tog(g, "Noclip", "Noclip")
	tog(g, "Pulo infinito", "InfJump")
	tog(g, "Andar na água", "Water", function() GM.applyWater() end)
	slider(g, "Gravidade", 20, 300, "Gravity", function(v) workspace.Gravity = v end)
	tog(g, "Reconectar se cair", "AutoRejoin")

	-- VISUAL
	section(pV, "Ambiente")
	g = group(pV, "visual")
	tog(g, "Fullbright", "Fullbright", function() GM.applyLight() end)
	tog(g, "Remover neblina", "NoFog", function() GM.applyLight() end)
	slider(g, "Campo de visão", 30, 120, "FOV", function(v) cam.FieldOfView = v end)
	button(g, "Modo desempenho (menos lag)", function() GM.boost() end)
	section(pV, "Efeitos do painel")
	g = group(pV, "visual")
	slider(g, "Transparência do vidro", 0, 60, "GlassAlpha", function() AHX.glass() end, "%")
	toggle(g, "Desfocar o jogo atrás do painel", "Blur")
	slider(g, "Intensidade do desfoque", 2, 24, "BlurSize")
	toggle(g, "Cartões com profundidade", "Cards3D", function() AHX.glass() end)
	toggle(g, "Animação escalonada ao abrir abas", "Stagger")
	toggle(g, "Esqueleto de carregamento", "Skeleton")
	dropdown(g, "Partículas dentro do painel", {"Runes", "Neve", "Nenhuma"}, "PartType", function(v) S.Runes = (v == "Runes") end)
	dropdown(g, "Densidade", {"Compacto", "Normal", "Espaçoso"}, "Density", function() AHX.layout() end)
	toggle(g, "Modo foco", "Focus", function() AHX.layout() end)
	toggle(g, "Barra lateral compacta", "Compact", function() AHX.layout() end)

	-- RÁPIDO (presets + favoritos)
	section(pQ, "Presets")
	g = group(pQ, "quick")
	local AUTOS = {AutoLevel = 1, Farm = 1, AutoBoss = 1, AutoElite = 1, Chest = 1, FruitGrab = 1, Sniper = 1, Bring = 1, Safe = 1, Click = 1, Skills = 1, EspFruits = 1, EspBosses = 1}
	local function preset(list)
		local want = {}
		for _, k in ipairs(list) do want[k] = true end
		for k in pairs(AUTOS) do if S[k] and not want[k] then setFeat(k, false) end end
		for _, k in ipairs(list) do setFeat(k, true) end
		syncAll()
		toast("Presets", "OK", 2)
	end
	button(g, "Farm Level", function() preset({"AutoLevel", "Click", "AutoEquip", "Buso", "Bring"}) end, true)
	button(g, "Fruit Hunter", function() preset({"FruitGrab", "Sniper", "AutoStore", "FruitNotify", "EspFruits"}) end, true)
	button(g, "Boss Farmer", function() preset({"AutoBoss", "Click", "AutoEquip", "Safe", "EspBosses", "Buso"}) end, true)
	button(g, "AFK Seguro", function() preset({"AutoLevel", "Click", "Safe", "Buso"}) end, true)
	section(pQ, "Favoritos")
	AHX.favG = group(pQ, "quick")
	AHX.rebuildQuick = function()
		clearGroup(AHX.favG)
		local any = false
		for _, k in ipairs(AHX.featOrder) do
			if S.Fav[k] then
				any = true
				local f = AHX.feat[k]
				toggle(AHX.favG, f.text, k, f.cb)
			end
		end
		if not any then rowItem(AHX.favG, "Toque na ☆ de uma função para fixá-la aqui.", {}) end
	end
	AHX.rebuildQuick()

	-- ATIVOS
	section(pA, "Ativos")
	g = group(pA, "active")
	button(g, "Desligar tudo", function()
		for _, k in ipairs(AHX.featOrder) do if S[k] then setFeat(k, false) end end
		syncAll(); AHX.lastSig = nil
	end, true)
	AHX.actG = group(pA, "active")
	GM.loop(1, function()
		local sig = {}
		for _, k in ipairs(AHX.featOrder) do if S[k] then sig[#sig + 1] = k end end
		local s = table.concat(sig, ",")
		if s == AHX.lastSig then return end
		AHX.lastSig = s
		clearGroup(AHX.actG)
		if #sig == 0 then rowItem(AHX.actG, "Nenhuma função ativa.", {}) end
		for _, k in ipairs(sig) do
			rowItem(AHX.actG, AHX.feat[k].text, {{t = "Desligar", w = 64, cb = function() setFeat(k, false); syncAll(); AHX.lastSig = nil end}})
		end
	end)

	-- PAINEL: cartão do jogador
	section(pg.home, "Jogador")
	g = group(pg.home, "home")
	info(g, "Level", function() return GM.fmt(GM.val("Level") or 0) end)
	info(g, "Beli", function() return GM.fmt(GM.val("Beli") or 0) end)
	info(g, "Fragments", function() return GM.fmt(GM.val("Fragments") or 0) end)
	info(g, "Fruta", function() local v = GM.val("DevilFruit") return (v and v ~= "") and tostring(v) or "—" end)
	info(g, "Mar", function() return tostring(GM.sea()) end)

	AHX.pages = {pS = pS}
end)

------------------------------------------------------------------
-- B4) CONFIGURAÇÕES, TEMAS, ORDEM DAS ABAS E MOBILE
------------------------------------------------------------------
AHX.run(function()
	local pS = AHX.pages.pS
	section(pS, "Idioma")
	local g = group(pS, "settings")
	dropdown(g, "Idioma", AHX.LN, "LangName", function(name)
		for i, n in ipairs(AHX.LN) do if n == name then AHX.setLang(AHX.LC[i]) return end end
	end)
	dropdown(g, "Fonte", AHX.FONTS, "Font", applyFont)

	local function swatchGrid(cellW, cellH)
		return new("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = ord(pS), Parent = pS},
			{new("UIGridLayout", {CellSize = UDim2.fromOffset(cellW, cellH), CellPadding = UDim2.fromOffset(6, 6), SortOrder = Enum.SortOrder.LayoutOrder})})
	end
	section(pS, "Tema")
	local tg, tstroke = swatchGrid(86, 42), {}
	for _, name in ipairs(AHX.THEME_ORDER) do
		local th = AHX.THEMES[name]
		local b = new("TextButton", {BackgroundColor3 = AHX.C(th.bg), Text = "", AutoButtonColor = false, Parent = tg}, {corner(6)})
		new("Frame", {Size = UDim2.new(1, -12, 0, 6), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = AHX.C(th.acc), BorderSizePixel = 0, Parent = b}, {corner(3)})
		new("TextLabel", {Size = UDim2.new(1, 0, 0, 18), Position = UDim2.fromOffset(0, 20), BackgroundTransparency = 1, Text = name, Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = AHX.C(th.text), Parent = b})
		tstroke[name] = new("UIStroke", {Color = AHX.C(th.acc), Thickness = 2, Enabled = (S.Theme == name), Parent = b})
		b.MouseButton1Click:Connect(function() click(); S.UseCustomAcc = false; AHX.applyTheme(name); syncAll() end)
	end
	AHX.themeStrokes = function() for n, s in pairs(tstroke) do s.Enabled = (S.Theme == n) end end
	section(pS, "Cor de destaque")
	local ag = swatchGrid(40, 40)
	for _, n in ipairs(ACC_ORDER) do
		local b = new("TextButton", {BackgroundColor3 = ACCENTS[n], Text = "", AutoButtonColor = false, Parent = ag}, {corner(20)})
		b.MouseButton1Click:Connect(function() click(); S.UseCustomAcc = false; S.Accent = n; AHX.setAccColor(ACCENTS[n]); syncAll() end)
	end
	g = group(pS, "settings")
	local function custAcc() if S.UseCustomAcc then AHX.setAccColor(Color3.fromRGB(S.AccR, S.AccG, S.AccB)) end end
	toggle(g, "Usar cor RGB personalizada", "UseCustomAcc", custAcc)
	slider(g, "Vermelho", 0, 255, "AccR", custAcc)
	slider(g, "Verde", 0, 255, "AccG", custAcc)
	slider(g, "Azul", 0, 255, "AccB", custAcc)
	section(pS, "Tema por horário")
	g = group(pS, "settings")
	toggle(g, "Trocar tema entre dia e noite", "ThemeAuto")
	dropdown(g, "Tema do dia", AHX.THEME_ORDER, "DayTheme")
	dropdown(g, "Tema da noite", AHX.THEME_ORDER, "NightTheme")
	GM.loop(30, function()
		if not S.ThemeAuto then return end
		local h = tonumber(os.date("%H")) or 12
		local name = (h >= 19 or h < 7) and S.NightTheme or S.DayTheme
		if name ~= S.Theme then AHX.applyTheme(name) end
	end)
	section(pS, "Aparência")
	g = group(pS, "settings")
	slider(g, "Tamanho do painel", 60, 130, "ScalePct", function(v) uis.Scale = v / 100 end, "%")
	slider(g, "Transparência do vidro", 0, 60, "GlassAlpha", function() AHX.glass() end, "%")
	dropdown(g, "Densidade", {"Compacto", "Normal", "Espaçoso"}, "Density", function() AHX.layout() end)
	toggle(g, "Barra lateral compacta", "Compact", function() AHX.layout() end)
	toggle(g, "Modo foco", "Focus", function() AHX.layout() end)
	section(pS, "Mobile")
	g = group(pS, "settings")
	toggle(g, "Botões grandes (toque)", "TouchBig", function() AHX.touch() end)
	toggle(g, "Deslizar para trocar de aba", "SwipeTabs")
	toggle(g, "Toque longo abre opções rápidas", "LongPress")
	toggle(g, "Vibração (controle)", "Haptic")
	section(pS, "Sons da interface")
	g = group(pS, "settings")
	toggle(g, "Sons da interface", "Sounds")
	slider(g, "Volume dos sons", 5, 100, "Volume", nil, "%")
	toggle(g, "Runas reativas à música", "RuneReact")
	toggle(g, "Som ambiente baixinho", "Ambient")
	input(g, "ID do som ambiente", "só números", function(t) S.AmbientId = t; toast("Ambient", t, 2) end)
	slider(g, "Volume ambiente", 2, 60, "AmbientVol", nil, "%")
	section(pS, "Janela")
	g = group(pS, "settings")
	dropdown(g, "Estilo de arrastar", {"Smooth", "Instant"}, "DragStyle")
	toggle(g, "Reduzir movimento", "ReducedMotion")
	toggle(g, "Ocultar meu nome", "HideName", refreshNames)
	toggle(g, "Toasts dentro do painel", "ToastInside")
	dropdown(g, "Tecla de mostrar/esconder", {"RightShift", "RightControl", "LeftAlt", "Insert", "K", "M", "P"}, "ToggleKey")
	button(g, "Resetar posições flutuantes", function()
		for _, d in ipairs(drags) do d.goal = d.home; d.t.Position = d.home end
		toast("Apple Hub", "OK", 2)
	end)
	-- ordem das abas (▲ ▼)
	section(pS, "Ordem das abas")
	local og = group(pS, "settings")
	AHX.defaultOrder = {"home", "farm", "combat", "fruits2", "esp2", "player", "visual", "tp", "inv", "wh", "quick", "active", "settings", "about"}
	local function rebuildPick()
		for _, c in ipairs(pick:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
		for _, id in ipairs(AHX.ids) do
			local b = txt({Size = UDim2.new(1, 0, 0, 26), Text = "  " .. pages[id].label, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, ZIndex = 31, Parent = pick}, false, "text", "TextButton")
			b.MouseButton1Click:Connect(function() click(); pick.Visible = false; showPage(id) end)
		end
	end
	local function applyOrder()
		local ids, seen = {}, {}
		for _, id in ipairs(S.TabOrder) do if pages[id] and AHX.isVisible[id] and not seen[id] then ids[#ids + 1] = id; seen[id] = true end end
		for _, id in ipairs(AHX.defaultOrder) do if pages[id] and not seen[id] then ids[#ids + 1] = id; seen[id] = true end end
		AHX.ids = ids
		for id, p in pairs(pages) do p.tb.Visible = AHX.isVisible[id] == true end
		for i, id in ipairs(ids) do pages[id].tb.LayoutOrder = i end
		rebuildPick()
		AHX.rescan()
	end
	local function refreshOrder()
		clearGroup(og)
		for i, id in ipairs(AHX.ids) do
			rowItem(og, pages[id].label, {
				{t = "▼", w = 30, cb = function()
					if AHX.ids[i + 1] then AHX.ids[i], AHX.ids[i + 1] = AHX.ids[i + 1], AHX.ids[i]; S.TabOrder = {table.unpack(AHX.ids)}; applyOrder(); refreshOrder() end
				end},
				{t = "▲", w = 30, cb = function()
					if i > 1 then AHX.ids[i], AHX.ids[i - 1] = AHX.ids[i - 1], AHX.ids[i]; S.TabOrder = {table.unpack(AHX.ids)}; applyOrder(); refreshOrder() end
				end},
			})
		end
		AHX.rescan()
	end
	applyOrder()
	refreshOrder()
	button(og, "Restaurar ordem padrão", function() S.TabOrder = {}; applyOrder(); refreshOrder() end)
	-- dados
	section(pS, "Dados")
	g = group(pS, "settings")
	input(g, "Link de versão (opcional)", "URL que retorna um número", function(u) S.UpdateUrl = u; toast("Update", u, 2) end)
	button(g, "Salvar configurações", function()
		local ok = pcall(function() writefile(FILE, HS:JSONEncode(S)) end)
		if ok then AHX.saveCheck() end
		toast("Config", ok and "OK" or "Seu executor não salva arquivos.", 3)
	end, true)
	button(g, "Apagar configurações salvas", function() pcall(function() if isfile(FILE) then delfile(FILE) end end) toast("Config", "OK", 2) end)
	button(g, "Descarregar hub", function() if getgenv and getgenv().AppleBloxUnload then getgenv().AppleBloxUnload() end end)
	-- som ambiente
	local amb = new("Sound", {Name = "AppleBloxAmbient", Looped = true, Parent = SoundService})
	GM.loop(1, function()
		local id = tostring(S.AmbientId):gsub("%D", "")
		if S.Ambient and id ~= "" and shown then
			local sid = "rbxassetid://" .. id
			if amb.SoundId ~= sid then amb.SoundId = sid end
			amb.Volume = S.AmbientVol / 100
			if not amb.IsPlaying then amb:Play() end
		elseif amb.IsPlaying then amb:Pause() end
	end)
	gui.Destroying:Connect(function() pcall(function() amb:Destroy() end) end)
	-- botões grandes (toque)
	AHX.touch = function()
		local k = S.TouchBig and 1.22 or 1
		for _, gr in ipairs(groups) do
			for _, r in ipairs(gr.rows) do
				for _, c in ipairs(r.f:GetChildren()) do
					if c:IsA("TextButton") and c.Size.X.Offset == 38 and c.Size.Y.Offset == 20 then
						local u = c:FindFirstChild("AHT")
						if not u then
							u = new("UIScale", {Name = "AHT", Parent = c})
							c.AnchorPoint = Vector2.new(0.5, 0.5); c.Position = UDim2.new(1, -31, 0.5, 0)
						end
						u.Scale = k
					end
				end
			end
		end
	end
	GM.loop(4, function() if S.TouchBig or AHX.touched then AHX.touched = S.TouchBig; AHX.touch() end end)
	-- deslizar para trocar de aba (ignora quando você está arrastando um slider)
	local sx, sy, sblock
	track(UIS.TouchStarted:Connect(function(t)
		local p, ap, as = t.Position, content.AbsolutePosition, content.AbsoluteSize
		if shown and p.X >= ap.X and p.X <= ap.X + as.X and p.Y >= ap.Y and p.Y <= ap.Y + as.Y then
			sx, sy, sblock = p.X, p.Y, false
			task.defer(function() local pg2 = pages[cur] if pg2 and not pg2.sc.ScrollingEnabled then sblock = true end end)
		else sx = nil end
	end))
	track(UIS.TouchEnded:Connect(function(t)
		if not sx or not S.SwipeTabs then sx = nil return end
		local dx, dy = t.Position.X - sx, t.Position.Y - sy
		local blocked = sblock
		sx = nil
		if blocked then return end
		if math.abs(dx) > 140 and math.abs(dy) < 40 then
			local i = 1
			for k, id in ipairs(AHX.ids) do if id == cur then i = k end end
			i = i + (dx < 0 and 1 or -1)
			if i < 1 then i = #AHX.ids elseif i > #AHX.ids then i = 1 end
			showPage(AHX.ids[i])
		end
	end))
	-- animação escalonada + esqueleto de carregamento ao abrir uma aba
	local lastCur, seenPg = nil, {}
	local function skeleton()
		local ov = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = T.bg, BorderSizePixel = 0, ZIndex = 25, Parent = content})
		for i = 1, 5 do
			local gr = new("UIGradient", {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.45), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 0.45)}), Offset = Vector2.new(-1, 0)})
			new("Frame", {Size = UDim2.new(1, -22, 0, 34), Position = UDim2.fromOffset(10, 10 + (i - 1) * 44), BackgroundColor3 = T.card, BorderSizePixel = 0, ZIndex = 26, Parent = ov}, {corner(6), gr})
			tw(gr, 0.5, {Offset = Vector2.new(1, 0)}, Enum.EasingStyle.Linear)
		end
		task.delay(0.45, function() pcall(function() ov:Destroy() end) end)
	end
	GM.loop(0.05, function()
		if cur == lastCur or not cur then return end
		lastCur = cur
		local p = pages[cur]
		if not p or S.ReducedMotion then return end
		if S.Stagger then
			local i = 0
			for _, c in ipairs(p.sc:GetChildren()) do
				if c:IsA("Frame") then
					i = i + 1
					local sc = c:FindFirstChild("AHS") or new("UIScale", {Name = "AHS", Parent = c})
					sc.Scale = 0.93
					task.delay(math.min(i * 0.035, 0.5), function() if sc.Parent then tw(sc, 0.35, {Scale = 1}, Enum.EasingStyle.Back) end end)
				end
			end
		end
		if S.Skeleton and not seenPg[cur] then seenPg[cur] = true; skeleton() end
	end)
	-- aviso de atualização no rodapé da barra lateral
	if S.UpdateUrl ~= "" then
		task.spawn(function()
			local ok, v = pcall(function() return game:HttpGet(S.UpdateUrl) end)
			if ok and tonumber(v) and tonumber(v) > 1.1 and AHX.sub then AHX.sub.Text = "Blox Edition • v1.1 ⬆" end
		end)
	end
	-- aplica tudo ao abrir (mantém o acento escolhido antes, se houver)
	local savedAcc = S.Accent
	AHX.applyTheme(S.Theme)
	if savedAcc ~= "Copper" and ACCENTS[savedAcc] and not S.UseCustomAcc then
		S.Accent = savedAcc
		AHX.setAccColor(ACCENTS[savedAcc])
	end
	AHX.layout()
	AHX.glass()
	AHX.touch()
	AHX.rescan()
	toast("Apple Hub", "v1.1 ✦", 3)
end)
