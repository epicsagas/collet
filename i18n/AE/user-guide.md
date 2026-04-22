> **ملاحظة:** تمت ترجمة هذا المستند بواسطة الذكاء الاصطناعي وقد لا تكون دقيقة بنسبة 100٪. إذا وجدت أي أخطاء أو كان لديك اقتراحات للتحسين، فيرجى فتح مشكلة على GitHub.

# دليل مستخدم Collet
دليل المستخدم الكامل لـ collet — منسق البرمجة المعتمد على الوكلاء الذي لا يكل.

## جدول المحتويات
1. مرجع واجهة سطر الأوامر (CLI Reference)
2. استخدام واجهة المستخدم الطرفية (TUI Usage)
3. تكوين موفرين متعددين (Multi-Provider Configuration)
4. خوادم MCP
5. ذكاء الكود (Code Intelligence)
6. التعاون بين وكلاء متعددين (Multi-Agent Collaboration)
7. واجهة الويب (Web Interface)
8. البوابة البعيدة (Telegram / Slack / Discord)
9. نظام المهارات (Skills System)
10. Soul.md — شخصية الوكيل
11. إدارة الجلسات (Session Management)
12. متغيرات البيئة (Environment Variables)
13. المرجع التكويني (Configuration Reference)
14. مسارات تخزين الملفات
15. الخصوصية والقياس عن بعد (Privacy & Telemetry)
16. محرك التطور (Evolution Engine)
17. نظام الإضافات (Plugin System)

## مرجع واجهة سطر الأوامر (CLI Reference)

### الأوامر الأساسية
```bash
collet                              # واجهة TUI تفاعلية
collet "fix the bug in main.rs"     # وضع بدون واجهة (ينفذ ثم يخرج)
collet --continue                   # استعادة آخر جلسة غير مكتملة
collet --resume                     # الاختيار من قائمة الجلسات
collet --model glm-5                # تجاوز النموذج الافتراضي
```

### الأوامر الفرعية
```bash
collet setup                        # إنشاء ملف التكوين (تسجيل موفرين متعددين)
collet secure                       # تشفير وتخزين مفتاح API
collet unsecure                     # إزالة بيانات الاعتماد المشفرة
collet status                       # التحقق من التكوين الحالي
collet update                       # التحقق من أحدث إصدار
collet --version                    # عرض الإصدار
collet help | -h | --help           # المساعدة
```

### إدارة الموفرين (Provider Management)
```bash
collet provider add                 # إضافة موفر (واجهة اختيار النموذج الموصى بها)
collet provider add openai          # إضافة موفر محدد مباشرة
collet provider list                # سرد الموفرين المسجلين
collet provider use <name>          # التبديل إلى الموفر النشط
```
الموفرون المدعومون: Z.ai, OpenAI, Anthropic, Google Gemini, DeepSeek, Mistral, Groq, Ollama, LM Studio, OpenRouter, Together AI, Azure OpenAI, Amazon Bedrock, Custom
Ollama و LM Studio عبارة عن خوادم محلية ولا تتطلب مفتاح API.

### إدارة MCP
```bash
collet mcp                          # التحقق من تكوين خادم MCP
collet mcp add <name> -c <cmd>      # إضافة خادم MCP
collet mcp remove <name>            # إزالة خادم MCP
```

### أعلام واجهة سطر الأوامر (CLI Flags)
العلم|الاختصار|الوصف
--dir <path>|-d|تحديد دليل العمل (مسار المشروع)
--continue|-c|استئناف تلقائي لآخر جلسة غير مكتملة
--resume|-r|الاختيار من نافذة قائمة الجلسات المنبثقة
--resume <id>|-r <id>|استئناف جلسة محددة بواسطة المعرف (ID)
--model <name>||تجاوز النموذج
--yolo||اعتماد تلقائي (Auto-commit)، تخطي التأكيدات
--watch||إعادة التشغيل عند تغيير الملفات
--ext <exts>||مراقبة امتدادات مستهدفة (مفصولة بفاصلة)
--debounce <ms>||تأخير المراقبة (الافتراضي: 2000)
--cwd <path>||دليل المراقبة (الافتراضي: الموقع الحالي)
--agent <name>|-a|استخدام وكيل مخصص
--fast|-f|الوضع السريع: بدون شريط جانبي، بدون تنسيق سرب، بدون تأمل الروح

### وضع بدون واجهة (Headless Mode)
```bash
collet "fix the login bug"                    # تشغيل في الدليل الحالي
collet "fix the login bug" -d ~/projects/api  # تشغيل في مشروع مختلف
collet "lint this" --yolo                     # اعتماد تلقائي، تخطي التأكيدات
collet "lint this" --fast                    # الوضع السريع: عبء الحد الأدنى
```

### وضع المراقبة (كشف تغيير الملفات)
```bash
# الاستخدام الأساسي
collet "lint this" --watch --ext rs,toml --debounce 500

# مراقبة دليل محدد فقط
collet "run tests" --watch --cwd ./src --ext rs

# استخدام وكيل مخصص
collet "review changes" --watch --agent reviewer --ext ts,tsx
```
يعيد التشغيل تلقائيًا عند تغيير الملفات.
حالات الاستخدام:
[1] السيناريو: مراقبة دليل فرعي محدد، الأمر: --watch --cwd ./packages/core
[2] السيناريو: كشف تغييرات ملف التكوين، الأمر: --watch --cwd ./config --ext yaml,toml
[3] السيناريو: إصلاح تلقائي لبرامج CI النصية، الأمر: --watch --cwd .github --ext yml
[4] السيناريو: تنسيق تلقائي للوثائق، الأمر: --watch --cwd ./docs --ext md
[5] السيناريو: فحص سريع (Linting) بنموذج خفيف، الأمر: --watch --agent fast --ext ts

## استخدام واجهة المستخدم الطرفية (TUI Usage)

### اختصارات المفاتيح
التنقل
المفتاح|الإجراء
Enter|إرسال الرسالة
Shift+Enter / Ctrl+J|سطر جديد (إدخال متعدد الأسطر)
↑ / ↓|متعدد الأسطر: التنقل بين الأسطر / سطر واحد: التنقل في السجل
Shift+↑/↓|تمرير المخرجات
PgUp / PgDn|تمرير سريع
Tab / Shift+Tab|التبديل بين الوكلاء للأمام / للخلف
Ctrl+C|أثناء التشغيل: إلغاء المهمة / عند الخمول: اضغط مرتين للخروج
Esc|أثناء التشغيل: إلغاء (اضغط مرتين) / إغلاق النافذة المنبثقة

تحرير النص
المفتاح|الإجراء
Ctrl+A / Cmd+←|انتقال إلى بداية السطر
Ctrl+E / Cmd+→|انتقال إلى نهاية السطر
Ctrl+← / Ctrl+→|انتقال كلمة لليسار / لليمين
Alt+← / Alt+→ / Alt+B / Alt+F|انتقال كلمة لليسار / لليمين (macOS Option+Arrow)
Backspace|حذف الحرف قبل المؤشر
Delete|حذف الحرف بعد المؤشر
Ctrl+W / Alt+Backspace|حذف الكلمة قبل المؤشر
Ctrl+Backspace|حذف الكلمة قبل المؤشر (Linux / Windows)
Cmd+Backspace|حذف حتى بداية السطر (macOS, Kitty-protocol terminals)
Ctrl+U|حذف حتى بداية السطر (جميع المنصات)
Ctrl+K|حذف حتى نهاية السطر

### الوكلاء المدمجون
يأتي Collet مع أربعة وكلاء مدمجين. يمكن التبديل بينهم باستخدام Tab / Shift+Tab.
[1] الوكيل: Arbor (افتراضي)، الدور: منسق مستقل تمامًا — يقرر تلقائيًا بين وضع الوكيل الفردي أو وضع السرب (swarm) لكل مهمة. لا توجد نوافذ منبثقة ولا يتطلب تكوينًا.
[2] الوكيل: Architect، الدور: وكيل التصميم والتخطيط. ينتج خطة منظمة، ثم يقترح /proceed ← Code أو /save-plan للحفظ.
[3] الوكيل: Code، الدور: وكيل البرمجة الافتراضي لمهام التنفيذ.
[4] الوكيل: Ask، الدور: وكيل محادثة / إجابة على الأسئلة بدون الوصول إلى الأدوات.
نصيحة: عندما يكون Arbor نشطًا، يتم توجيه مهمتك تلقائيًا إلى وضع التنفيذ الأمثل (Fork / Hive / Flock / وكيل فردي). بالنسبة للوكلاء الآخرين، يتم دائمًا احترام اختيارك كوكيل أساسي.

### أوامر Slash
الأمر|الوصف
/help|المساعدة
/clear|إعادة ضبط المحادثة
/compact|ضغط السياق يدويًا
/cost|إحصائيات استخدام الرموز (Tokens)
/diff|تغييرات Git
/sdiff|مقارنة التغييرات جنبًا إلى جنب (Side-by-side diff)
/undo|التراجع عن آخر اعتماد (Commit)
/models [name]|فتح منتقي النماذج أو تبديل النموذج مباشرة
Tab / Shift+Tab|التبديل بين الوكلاء
/search <query>|بحث ذو صلة باستخدام BM25
/rewind [id]|الرجوع إلى نقطة تفتيش (Checkpoint)
/checkpoints|سرد نقاط التفتيش
/web <url>|جلب محتوى الرابط
/resume|نافذة الجلسات الأخيرة المنبثقة — مرتبة حسب الأحدث
/theme [name]|تغيير سمة الألوان (6 خيارات: default, dracula, catppuccin-mocha, tokyo-night, nord, gruvbox)
/save-plan|حفظ خطة وضع Architect في ملف
/proceed|الموافقة على خطة Architect والتبديل إلى وضع Code
/cancel-plan|إهمال خطة Architect
/fork|تفرع الوكلاء المتوازي
/hive|التعاون القائم على الإجماع
/flock|تعاون وكلاء متعددين في الوقت الفعلي
/mcp|إدارة خوادم MCP (المسافة: تشغيل/إيقاف، a: إضافة، d: إزالة)
/skills|سرد المهارات
/agents|عرض الوكلاء الفرعيين النشطين
/optimize|تحسين السياق
/bench|لوحة معلومات الأداء
/debug|تبديل تراكب تصحيح الأخطاء
/telemetry|التحقق من حالة القياس عن بعد والعناصر التي تم جمعها
/quit|الخروج

الإكمال التلقائي: اكتب / لفتح نافذة الأوامر المنبثقة. تظهر كل من الأوامر المدمجة والمهارات المكتشفة في نفس القائمة. استخدم ↑/↓ للتنقل، Tab للتوسيع، و Enter للتأكيد.

### تمرير أوامر الصدفة (Shell Passthrough)
أضف البادئة ! لأي أمر صدفة لتشغيله مباشرة في دليل العمل دون مغادرة TUI:
```
! git log --oneline -5
! cargo test
! ls src/
```
يتم عرض رمز الخروج و stdout و stderr ككتلة برمجية في المحادثة. مفيد للتحقق السريع.

### الإشارات @ (Mentions)
[1] النمط: @src/main.rs، الإجراء: إرفاق محتوى الملف بالسياق
[2] النمط: @src، الإجراء: إرفاق هيكل شجرة المجلد (3 مستويات، 200 عنصر)
[3] النمط: @Makefile، الإجراء: كشف تلقائي للملف/المجلد بالنسبة لدليل العمل الحالي
[4] النمط: @glm-5، الإجراء: تبديل الوكيل إلى النموذج المحدد

الإكمال التلقائي: اكتب @ لفتح نافذة الإشارات المنبثقة.

### أدوات الوكيل (Agent Tools)
الأداة|الوصف
bash|تنفيذ أوامر الصدفة (مع حماية المهلة)
file_read|قراءة ملف مع أرقام الأسطر
file_write|إنشاء/استبدال ملف
file_edit|استبدال نص محدد بدقة (Surgical Edit)
git_patch|تطبيق ترقيعات (Patches) قائمة على الكتل (Hunks)
search|بحث عن الكود باستخدام ripgrep
skill|تحميل مهارة الوكيل (تقدم تدريجي من 3 مستويات)
subagent|تنفيذ مهمة فرعية في سياق معزول

## خوادم MCP
قم بتوصيل خوادم Model Context Protocol لتوسيع أدوات الوكيل.

### إضافة الخوادم
```bash
# من حزمة npm
/mcp add npm:@anthropic/mcp-server-filesystem

# ملف ثنائي محلي
/mcp add local:/path/to/server --name myserver

# نقطة نهاية HTTP
/mcp add http:https://api.example.com/mcp

# إضافة عالمية (لكل المشاريع)
/mcp add npm:@some/tool --global
```

### إدارة الخوادم
```bash
/mcp enable myserver
/mcp disable myserver
/mcp remove myserver
```

### ملف التكوين
.collet/mcp.json (للمشروع) أو ~/.collet/mcp.json (عالمي):
```json
{
  "mcpServers": {
    "my-server": {
      "command": "npx",
      "args": ["-y", "@my/mcp-server"],
      "env": { "API_KEY": "${MY_API_KEY}" }
    },
    "remote-api": {
      "url": "https://api.example.com/mcp",
      "headers": { "Authorization": "Bearer ${API_TOKEN}" }
    }
  }
}
```

## ذكاء الكود (Code Intelligence)
يعمل تلقائيًا دون إعداد إضافي.
1. الفهرسة — عند البدء، يقوم Tree-sitter بتحليل المصدر واستخراج الرموز. يتم معالجة الملفات المغيرة فقط باستخدام تشفير BLAKE3.
2. الحقن التلقائي — يحلل رسائل المستخدم؛ للأسئلة المتعلقة بالكود، يجد الملفات ذات الصلة باستخدام BM25 ويحقنها تلقائيًا في السياق.
3. تقليل استخدام grep — يبلغ الوكيل أن الكود مفهرس مسبقًا، مما يقلل من استدعاءات grep/find غير الضرورية.
اللغات المدعومة: Rust, Python, TypeScript, JavaScript, Go, Java, C/C++, Ruby, PHP, Swift, Kotlin، وأكثر من 35 لغة أخرى.

## التعاون بين وكلاء متعددين
الهيكل: Fork < Hive < Flock
[1] الوضع: Fork، كيف يعمل: المنسق يقسم العمل → تنفيذ متوازٍ → دمج النتائج. الأفضل لـ: المهام الفرعية المستقلة.
[2] الوضع: Hive، كيف يعمل: التصويت بالإجماع بين الوكلاء، إشراف المنسق. الأفضل لـ: اتخاذ القرارات المعقدة.
[3] الوضع: Flock، كيف يعمل: مراسلة فورية بين الوكلاء (تجريبي). الأفضل لـ: التعاون شديد الارتباط.

## واجهة الويب (Web Interface)
استخدم collet في متصفحك. واجهة أمامية SvelteKit + خلفية Axum.

### البناء والتشغيل
```bash
# البناء (يتطلب علم ميزة web)
cargo build --release --features web

# التشغيل
collet web                    # http://127.0.0.1:3080
collet web -p 8080            # تغيير المنفذ
collet web --host 0.0.0.0     # السماح بالوصول الخارجي
collet web --password secret  # تمكين المصادقة
```

### خيارات واجهة سطر الأوامر
[1] الخيار: --host، -h، الافتراضي: 127.0.0.1، الوصف: عنوان الربط
[2] الخيار: --port، -p، الافتراضي: 3080، الوصف: منفذ الربط
[3] الخيار: --username، -u، الافتراضي: collet، الوصف: اسم مستخدم تسجيل الدخول
[4] الخيار: --password، الوصف: كلمة مرور المصادقة

## البوابة البعيدة (Remote Gateway - Telegram / Slack / Discord)
استخدم collet من منصات الدردشة.

### إدارة CLI
```bash
collet remote add [platform]   # إضافة محول (تفاعلي)
collet remote start            # البدء كخدمة خلفية (daemon)
collet remote stop             # إيقاف الخدمة
```

### أوامر الدردشة
[1] الأمر: /projects، الوصف: قائمة المشاريع
[2] الأمر: /sessions، الوصف: قائمة الجلسات
[3] الأمر: /new [path]، الوصف: بدء جلسة جديدة
[4] الأمر: /cancel، الوصف: إلغاء الوكيل الجاري تشغيله
[5] الأمر: /approve، الوصف: الموافقة على خطة التنفيذ

## نظام المهارات (Skills System)
توفير معرفة متخصصة للوكلاء عبر ملفات markdown مع YAML frontmatter.
المواقع:
- المشروع: .collet/skills/
- عالمي: ~/.config/collet/skills/

## Soul.md — شخصية الوكيل
بعد اكتمال كل مهمة، يفكر الوكيل في الجلسة ويسجل شخصيته تدريجيًا في ~/.collet/agents/souls/{name}.md. يتم كتابة جميع الأقسام بواسطة الوكيل نفسه.

## إدارة الجلسات
```bash
collet --continue                   # استئناف تلقائي لآخر جلسة غير مكتملة
collet --resume                     # الاختيار من قائمة الجلسات
collet --resume <id>                # استئناف جلسة محددة
```

## متغيرات البيئة (Environment Variables)
المتغير|الافتراضي|الوصف
COLLET_MODEL|glm-4.7|النموذج المستخدم
COLLET_MAX_TOKENS|8192|أقصى حد لرموز الاستجابة
COLLET_TOOL_TIMEOUT|120|مهلة استدعاء الأداة (ثوانٍ)
COLLET_THEME|default|سمة ألوان TUI

## مرجع التكوين (Configuration Reference)
هيكل config.toml: انظر docs/config.md للمرجع الكامل.

## مسارات تخزين الملفات
- ~/.config/collet/ : التكوين الملحوظ والمهارات العالمية.
- ~/.collet/ : السجلات وشخصيات الوكلاء وخوادم MCP العالمية.
- ~/.local/share/collet/ : بيانات الجلسات لكل مشروع.

## الخصوصية والقياس عن بعد (Privacy & Telemetry)
يجمع Collet إحصائيات استخدام مجهولة وتقارير أخطاء لتحسين المنتج.
يمكن تعطيله عبر:
```bash
export COLLET_TELEMETRY=0
```

## محرك التطور (Evolution Engine)
حلقة تحسين ذاتي حيث يقوم الوكيل بتحسين قدراته الخاصة.
```bash
collet evolve "fix the login bug"
```

## نظام الإضافات (Plugin System)
توسع الإضافات collet بأوامر ومهارات ووكلاء مخصصين. يتم تخزينها في ~/.collet/plugins/<name>/.

تثبيت الإضافات:
```bash
collet plugin install owner/repo
```
