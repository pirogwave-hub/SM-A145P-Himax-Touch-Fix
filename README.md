# Samsung Galaxy A14 (SM-A145P) Aftermarket Touchscreen Fix (Android 15 / One UI 7)

[🇷🇺 Русская версия](#-описание-проблемы-ru) | [🇺🇸 English version](#-problem-description-en)

---

## 🇷🇺 Описание проблемы (RU)

На смартфонах **Samsung Galaxy A14 (SM-A145P)** с установленным неоригинальным (китайским TFT/Incell) дисплейным модулем на контроллере **Himax HX83112F** после обновления на **Android 15 (One UI 7)** возникает специфический баг:
* Сразу после прошивки через Odin тачскрин работает идеально.
* **После первой перезагрузки сенсор полностью перестает реагировать на нажатия.**

### Причина
При холодной загрузке Android 15 ядро пытается инициализировать шину SPI раньше, чем контроллер неоригинального дисплея успевает выйти из режима инициализации, из-за чего устройство `spi2.0` не привязывается к драйверу `himax_tp` (модуль `himax_ic_HX83112_o22`).

### Решение
Данный модуль для **KernelSU** (также совместим с **Magisk**) дожидается полной загрузки системы (`sys.boot_completed=1`) и принудительно перепривязывает контроллер `spi2.0` к драйверу `himax_tp`.

### Требования
* Разблокированный загрузчик (Bootloader)
* Установленный **KernelSU** или **Magisk**

### Установка
1. Скачайте последний архив `.zip` из раздела **[Releases](../../releases)**.
2. Подключите USB-мышку через OTG-переходник (так как сенсор до установки модуля не работает).
3. Откройте приложение **KernelSU** (или **Magisk**) → **Модули** → **Установить из хранилища**.
4. Выберите скачанный `.zip` архив и перезагрузите смартфон.
5. После загрузки системы подождите 4–5 секунд — сенсор автоматически заработает.

### Адаптация под другие ревизии/модели
Если у вас другая ревизия дисплея или модель (например, SM-A145F), вы можете проверить свой драйвер и SPI-адрес через `adb shell` (с правами `su`):
```bash
# Найти имя драйвера тачскрина
ls /sys/bus/spi/drivers/

# Найти адрес контроллера на шине SPI
grep -rn "himax" /sys/bus/spi/devices/*/of_node/compatible 2>/dev/null
```
При необходимости замените `spi2.0` и `himax_tp` в файле `service.sh` на ваши значения.

---

## 🇺🇸 Problem Description (EN)

On **Samsung Galaxy A14 (SM-A145P)** devices equipped with an aftermarket (replacement TFT/Incell) display panel using the **Himax HX83112F** touch controller, updating to **Android 15 (One UI 7)** causes a specific issue:
* Right after flashing stock firmware via Odin, the touchscreen works fine.
* **After the very first reboot, the touchscreen stops responding completely.**

### Root Cause
During a cold boot on Android 15, the kernel probes the SPI bus before the aftermarket Himax touch controller finishes initializing. As a result, `spi2.0` fails to bind to the `himax_tp` driver (`himax_ic_HX83112_o22` kernel module).

### Solution
This **KernelSU** module (also compatible with **Magisk**) waits until Android finishes booting (`sys.boot_completed=1`) and forces a clean `unbind` / `bind` cycle for `spi2.0` on the `himax_tp` driver.

### Requirements
* Unlocked Bootloader
* **KernelSU** or **Magisk** installed

### Installation
1. Download the latest `.zip` package from **[Releases](../../releases)**.
2. Connect a USB mouse via an OTG adapter to navigate the UI.
3. Open **KernelSU** (or **Magisk**) → **Modules** → **Install from storage**.
4. Select the downloaded `.zip` file and reboot your device.
5. Wait 4–5 seconds after the lock screen appears — the touchscreen will initialize automatically.

### Adaptation for Other Revisions / Models
If your device uses a different display revision or SPI port (e.g., SM-A145F), check your driver and bus ID via `adb shell` (`su`):
```bash
# Check loaded SPI touch driver
ls /sys/bus/spi/drivers/

# Find the exact SPI bus address
grep -rn "himax" /sys/bus/spi/devices/*/of_node/compatible 2>/dev/null
```
Update `spi2.0` and `himax_tp` inside `service.sh` if your hardware uses different values.