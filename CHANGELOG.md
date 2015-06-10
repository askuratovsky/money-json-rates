JsonRates 0.1.0
=====================

Features
--------
 - Added rates_careful mode:
   - store rates with created_at
   - don't flush all the rates simultaneously
   - don't flush the rate if new one is unavailable
