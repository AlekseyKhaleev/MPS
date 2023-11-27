const cw_reset       11000011b    ; Команда сброса ВВ79
const cw_coded_scans 00000110b    ; Команда выбора нужного режима работы
const cw_write_aincr 10010000b    ; Команда записи в ОЗУ отображения
                                  ; с автоинкрементом
const mask_one       00000110b    ; Образ символа единицы (8-сегментный)
const mask_zero      00111111b    ; Образ символа нуля (8-сегментный)
const port_data      0            ; Порт ввода/вывода данных
const port_cmd       1            ; Порт вывода команд/ввода состояния

org 0h                           
jmp initialize                    ; Точка входа. Инициализация ниже

skip 38h                          ; ISR должна располагаться по этому адресу

:isr                              
in port_cmd                       ; Чистем слово состояния
ani 0Fh                           ; Есть байты в очереди ?
jz exit_isr                       ; Если нет, выходим из ISR
in port_data                      ; Ввод байта данных в A
call show_bit_mask                ; Вывод на индикаторы 
jmp isr                           ; Повторяем, пока есть символы

:exit_isr                         ; Выход с разрешением прерываний
ei
ret

:initialize                       ; Инициализация
mvi a, cw_reset                   ; Программный сброс
out port_cmd
mvi a, cw_coded_scans             ; Кодированное сканирование дисплея
out port_cmd                      ; и ввод по стробу
ei

:forever                          ; Вечный цикл
jmp forever                       ; Здесь могут происходить прерывания

:show_bit_mask                    ; Подпрограмма поразрядного вывода

mov b, a                          ; Выведем команду записи в ОЗУ
mvi a, cw_write_aincr             ; отображения с автоинкрементом
out port_cmd
mvi c, 8                          ; Всего 8 разрядов в байте ;)
mov a, b

:repeat
ral                               ; Поворот аккумулятора влево 
mov b, a                          ; Сохраним A в B
jnc show_zero                     ; Если текущий разряд - ноль...
mvi a, mask_one                   ; Иначе загружаем маску единицы
jmp do_show

:show_zero
mvi a, mask_zero                  ; Загружаем маску нуля

:do_show                          ; Выводим текущую маску
out port_data
mov a, b
dcr c                             ; И переходим к следующей итерации
jnz repeat

ret