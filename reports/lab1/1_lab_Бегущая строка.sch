<Schema><Elements><Element Name="I80" Library="KP580.dll" Left="167" Top="59" Caption="DD1-ЦП"><Property/></Element><Element Name="SC" Library="KP580.dll" Left="316" Top="56" Caption="DD2-системный контр-р"><Property/></Element><Element Name="dualgen" Library="ins2.dll" Left="360" Top="310" Caption="Генератор [2-1-4-2]x10"><Property delay_f1="2" delay_f1f2="1" delay_f2="4" delay_f2f1="2" multiplier="10"/></Element><Element Name="block4" Library="ins2.dll" Left="69" Top="243" Caption=""><Property state="6"/></Element><Element Name="And" Library="SimpleDigital.dll" Left="210" Top="316"><Property TpHL="10" TpLH="10" TpLZ="10" TpZL="10" TpHZ="10" TpZH="10"/></Element><Element Name="ram1k" Library="memory.dll" Left="612" Top="52" Caption="DD4-память"><Property delay_lh="10" delay_hl="10" delay_lz="10" delay_zl="10" delay_hz="10" delay_zh="10" synchronous="0" data="H1W0h2GBKwXF1ezJEG312O13imIN194Uoe2WS1e129Z7un2WDSq21OWs1Knm111111111111k4111W73CaWd1m01i0Wd71111a119uE1U31Q0u01111d1gD1311O5mP3WX1411P3c2W11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111W21" asmfile="C:\MPS\lab1\Пример выполнения л.р. 1\my1_lab1.asm"/></Element><Element Name="reg8" Library="memory.dll" Left="585" Top="250" Caption="DD5-регистр позиции"><Property delay_lh="10" delay_hl="10" delay_lz="10" delay_zl="10" delay_hz="10" delay_zh="10"/></Element><Element Name="reg8" Library="memory.dll" Left="28" Top="59" Caption="DD6-рег.упр. сегм-ми"><Property delay_lh="10" delay_hl="10" delay_lz="10" delay_zl="10" delay_hz="10" delay_zh="10"/></Element><Element Name="reg8" Library="memory.dll" Left="32" Top="354" Caption="DD7-рег. упр. сегм-ми"><Property delay_lh="10" delay_hl="10" delay_lz="10" delay_zl="10" delay_hz="10" delay_zh="10"/></Element><Element Name="addrselector" Library="extra.dll" Left="584" Top="423" Caption="DD8-адресный селектор"><Property range0_low="0x80" range0_high="0x80" range1_low="0x81" range1_high="0x81" range2_low="0x82" range2_high="0x82" range3_low="0x0" range3_high="0x0"/></Element><Element Name="m8e" Library="SWR.dll" Left="194" Top="384" Caption="DD9-цифровой индикатор"><Property backcolor="16777215" forecolor_off="15790320" forecolor_on="0" light_time="500000" linear_attenuation="12330752"/></Element></Elements><Buses><Bus Color="0"><Line Start.X="531" Start.Y="29" End.X="531" End.Y="591"><Conect Element="1" Pin="14" ID="d6"/><Conect Element="6" Pin="1" ID="d6"/><Conect Element="1" Pin="13" ID="d5"/><Conect Element="6" Pin="2" ID="d5"/><Conect Element="1" Pin="12" ID="d4"/><Conect Element="6" Pin="3" ID="d4"/><Conect Element="1" Pin="11" ID="d3"/><Conect Element="6" Pin="4" ID="d3"/><Conect Element="1" Pin="10" ID="d2"/><Conect Element="6" Pin="5" ID="d2"/><Conect Element="1" Pin="9" ID="d1"/><Conect Element="6" Pin="6" ID="d1"/><Conect Element="1" Pin="8" ID="d0"/><Conect Element="6" Pin="7" ID="d0"/><Conect Element="6" Pin="0" ID="d7"/><Conect Element="1" Pin="15" ID="d7"/><Conect Element="10" Pin="12" ID="C1"/><Conect Element="10" Pin="13" ID="C2"/><Conect Element="10" Pin="14" ID="C3"/><Conect Element="5" Pin="9" ID="A0"/><Conect Element="5" Pin="8" ID="A1"/><Conect Element="5" Pin="7" ID="A2"/><Conect Element="5" Pin="6" ID="A3"/><Conect Element="5" Pin="5" ID="A4"/><Conect Element="5" Pin="4" ID="A5"/><Conect Element="5" Pin="3" ID="A6"/><Conect Element="5" Pin="2" ID="A7"/><Conect Element="5" Pin="1" ID="A8"/><Conect Element="5" Pin="0" ID="A9"/><Conect Element="9" Pin="1" ID="G"/><Conect Element="9" Pin="2" ID="G"/><Conect Element="9" Pin="3" ID="G"/><Conect Element="9" Pin="4" ID="G"/><Conect Element="9" Pin="5" ID="G"/><Conect Element="6" Pin="9" ID="G"/><Conect Element="6" Pin="10" ID="G"/><Conect Element="5" Pin="12" ID="A15"/><Conect Element="9" Pin="0" ID="A15"/><Conect Element="1" Pin="22" ID="MR"/><Conect Element="5" Pin="10" ID="MR"/><Conect Element="1" Pin="24" ID="MW"/><Conect Element="5" Pin="11" ID="MW"/><Conect Element="9" Pin="8" ID="MW"/><Conect Element="9" Pin="7" ID="A0"/><Conect Element="9" Pin="6" ID="A1"/><Conect Element="6" Pin="8" ID="S1"/><Conect Element="2" Pin="0" ID="F1"/><Conect Element="2" Pin="1" ID="F2"/><Conect Element="10" Pin="19" ID="C8"/><Conect Element="10" Pin="18" ID="C7"/><Conect Element="10" Pin="17" ID="C6"/><Conect Element="10" Pin="16" ID="C5"/><Conect Element="10" Pin="15" ID="C4"/><Conect Element="10" Pin="10" ID="21"/><Conect Element="10" Pin="11" ID="22"/></Line><Line Start.X="291" Start.Y="29" End.X="291" End.Y="363"><Conect Element="0" Pin="23" ID="7"/><Conect Element="0" Pin="22" ID="6"/><Conect Element="0" Pin="21" ID="5"/><Conect Element="1" Pin="5" ID="5"/><Conect Element="1" Pin="4" ID="4"/><Conect Element="0" Pin="20" ID="4"/><Conect Element="0" Pin="19" ID="3"/><Conect Element="1" Pin="3" ID="3"/><Conect Element="1" Pin="2" ID="2"/><Conect Element="0" Pin="18" ID="2"/><Conect Element="0" Pin="17" ID="1"/><Conect Element="1" Pin="1" ID="1"/><Conect Element="1" Pin="0" ID="0"/><Conect Element="0" Pin="16" ID="0"/><Conect Element="1" Pin="6" ID="6"/><Conect Element="1" Pin="7" ID="7"/><Conect Element="4" Pin="2" ID="STB"/><Conect Element="1" Pin="16" ID="STB"/><Conect Element="0" Pin="28" ID="G"/><Conect Element="0" Pin="30" ID="G"/><Conect Element="1" Pin="20" ID="G"/><Conect Element="1" Pin="17" ID="G"/><Conect Element="0" Pin="34" ID="DBIN"/><Conect Element="1" Pin="19" ID="DBIN"/><Conect Element="1" Pin="18" ID="WR"/><Conect Element="0" Pin="35" ID="WR"/><Conect Element="0" Pin="33" ID="RDY"/></Line><Line Start.X="149" Start.Y="26" End.X="149" End.Y="522"><Conect Element="0" Pin="15" ID="A15"/><Conect Element="0" Pin="0" ID="A0"/><Conect Element="0" Pin="2" ID="A2"/><Conect Element="0" Pin="1" ID="A1"/><Conect Element="0" Pin="3" ID="A3"/><Conect Element="0" Pin="4" ID="A4"/><Conect Element="0" Pin="5" ID="A5"/><Conect Element="0" Pin="6" ID="A6"/><Conect Element="0" Pin="7" ID="A7"/><Conect Element="0" Pin="8" ID="A8"/><Conect Element="0" Pin="9" ID="A9"/><Conect Element="0" Pin="24" ID="F1"/><Conect Element="4" Pin="0" ID="F1"/><Conect Element="0" Pin="27" ID="Syn"/><Conect Element="4" Pin="1" ID="Syn"/><Conect Element="3" Pin="3" ID="G"/><Conect Element="7" Pin="18" ID="18"/><Conect Element="0" Pin="25" ID="F2"/><Conect Element="10" Pin="0" ID="11"/><Conect Element="10" Pin="1" ID="12"/><Conect Element="7" Pin="17" ID="17"/><Conect Element="7" Pin="16" ID="16"/><Conect Element="10" Pin="2" ID="13"/><Conect Element="10" Pin="3" ID="14"/><Conect Element="7" Pin="15" ID="15"/><Conect Element="7" Pin="14" ID="14"/><Conect Element="10" Pin="4" ID="15"/><Conect Element="10" Pin="5" ID="16"/><Conect Element="7" Pin="13" ID="13"/><Conect Element="7" Pin="12" ID="12"/><Conect Element="10" Pin="6" ID="17"/><Conect Element="10" Pin="7" ID="18"/><Conect Element="7" Pin="11" ID="11"/><Conect Element="10" Pin="8" ID="19"/><Conect Element="8" Pin="18" ID="22"/><Conect Element="8" Pin="17" ID="21"/><Conect Element="10" Pin="9" ID="20"/><Conect Element="8" Pin="16" ID="20"/><Conect Element="8" Pin="15" ID="19"/><Conect Element="3" Pin="0" ID="RES"/><Conect Element="0" Pin="26" ID="RES"/><Conect Element="3" Pin="1" ID="RDY"/><Conect Element="10" Pin="20" ID="EN"/><Conect Element="3" Pin="2" ID="EN"/></Line><Line Start.X="734" Start.Y="26" End.X="734" End.Y="588"><Conect Element="5" Pin="14" ID="d6"/><Conect Element="5" Pin="15" ID="d5"/><Conect Element="5" Pin="16" ID="d4"/><Conect Element="5" Pin="17" ID="d3"/><Conect Element="5" Pin="18" ID="d2"/><Conect Element="5" Pin="19" ID="d1"/><Conect Element="5" Pin="20" ID="d0"/><Conect Element="5" Pin="13" ID="d7"/><Conect Element="6" Pin="11" ID="C8"/><Conect Element="6" Pin="17" ID="C2"/><Conect Element="6" Pin="16" ID="C3"/><Conect Element="9" Pin="9" ID="S1"/><Conect Element="9" Pin="11" ID="S2"/><Conect Element="9" Pin="13" ID="S3"/><Conect Element="6" Pin="18" ID="C1"/><Conect Element="6" Pin="12" ID="C7"/><Conect Element="6" Pin="13" ID="C6"/><Conect Element="6" Pin="14" ID="C5"/><Conect Element="6" Pin="15" ID="C4"/></Line><Line Start.X="16" Start.Y="28" End.X="734" End.Y="28"/><Line Start.X="17" Start.Y="26" End.X="17" End.Y="523"><Conect Element="7" Pin="0" ID="d7"/><Conect Element="7" Pin="1" ID="d6"/><Conect Element="8" Pin="1" ID="d6"/><Conect Element="7" Pin="2" ID="d5"/><Conect Element="8" Pin="2" ID="d5"/><Conect Element="7" Pin="3" ID="d4"/><Conect Element="8" Pin="3" ID="d4"/><Conect Element="7" Pin="4" ID="d3"/><Conect Element="8" Pin="4" ID="d3"/><Conect Element="7" Pin="5" ID="d2"/><Conect Element="8" Pin="5" ID="d2"/><Conect Element="7" Pin="6" ID="d1"/><Conect Element="8" Pin="6" ID="d1"/><Conect Element="7" Pin="7" ID="d0"/><Conect Element="8" Pin="7" ID="d0"/><Conect Element="8" Pin="0" ID="d7"/><Conect Element="7" Pin="8" ID="S2"/><Conect Element="7" Pin="9" ID="G"/><Conect Element="7" Pin="10" ID="G"/><Conect Element="8" Pin="9" ID="G"/><Conect Element="8" Pin="10" ID="G"/><Conect Element="8" Pin="8" ID="S3"/></Line></Bus></Buses><Options PageWidth="1062" PageHeight="1010"/></Schema>
