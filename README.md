Prototyp gry/symulacji z perspektywy osoby top-down.
Zanim porzuciłem projekt, udało mi się osiągnąć kilka rzeczy:
  
  -Pathfinding agentów po navmap'ie generowanej na podstawie tilemap'y<img width="1914" height="1038" alt="obraz" src="https://github.com/user-attachments/assets/43b1bd21-bd29-43ed-a30c-eb315f3627d7" />Jak widać, generowana "struktura" automatycznie jest wyjęta spod navmap'y -> Scripts/city.gd + konfiguracja programu


  -Prosty model ekonomii sklepów (większa sprzedaż = wyższe ceny, niższa sprzedaż = niższe ceny) -> Scripts/Shop.gd

  
  -System agenta, posiadający własne mieszkanie, pracę oraz fundusze (relacje agent-agent nie skończone)
  
  <img width="735" height="921" alt="obraz" src="https://github.com/user-attachments/assets/820b997e-0d7a-43a8-83c4-9a44a0982117" />Tutaj przedstawione jest graficzna prezentacja zmiennych i tabel agenta -> Scripts/agent.gd


  -Częściowo ukończony system Timetable, używający posortowanej tabeli bloków własnej klasy (Scripts/time_block.gd) i wyszukujący ich na podstawie czasu start/end oraz priority samego bloku. Sam skrypt wyszukuje bloku poprzez szukanie binarne -> Scripts/time_block.gd + Scripts/agent.gd
