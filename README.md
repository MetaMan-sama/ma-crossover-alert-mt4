# Moving Average Crossover Alert — MQL4 Script

A MetaTrader 4 script that monitors **short-term and long-term moving average crossovers** by computing both MAs via `iMA()` each cycle, comparing current-bar values against persistent `PrevShortMA` and `PrevLongMA` globals to detect directional crossovers, and firing Golden Cross (bullish) or Death Cross (bearish) alerts when the short-term MA crosses above or below the long-term MA — with a rich alert message that includes both prior MA values for full crossover context.

---

## Overview

The moving average crossover is one of the oldest and most widely studied signals in technical analysis. A Golden Cross — when a shorter-period MA crosses above a longer-period MA — signals that near-term momentum is accelerating above the broader trend baseline, historically associated with the beginning of bullish momentum phases. A Death Cross — when the shorter MA crosses below the longer — signals that near-term momentum has deteriorated below the trend baseline, associated with the onset of bearish momentum. The power of the crossover signal lies not in either MA individually but in their relationship: when they separate in a directional move, it confirms that short-term price behavior has definitively shifted relative to the longer-term trend context. This script implements both crossover conditions using persistent prior-bar state variables, firing on the first bar where the crossover is confirmed and remaining quiet until the next reversal — preventing the alert flooding that would occur without state tracking.

> **Note on file naming:** This file is distributed as `Symbol_Loader_001.mq4` but implements a Moving Average Crossover alert. The README documents the actual implemented logic.

---

## Features

- **Dual-MA `iMA()` fetch** — `shortMA = iMA(TradeSymbol, Timeframe, ShortMAPeriod, 0, MAMethod, AppliedPrice, 1)` and `longMA = iMA(..., LongMAPeriod, ..., 1)` at bar 1 for confirmed values; `PrevShortMA` and `PrevLongMA` fetched at bar 2 for strict crossover detection
- **Strict crossover detection** — Golden Cross: `PrevShortMA <= PrevLongMA && shortMA > longMA`; Death Cross: `PrevShortMA >= PrevLongMA && shortMA < longMA` — equality guards (`<=` / `>=`) prevent false triggers when MAs are momentarily equal
- **Rich alert message** — `AlertCross()` formats with `"Short MA: %.5f, Long MA: %.5f"` showing prior-bar values for full crossover context alongside signal type and timeframe
- **Persistent prior-bar state** — `PrevShortMA` and `PrevLongMA` globals updated unconditionally at cycle end from fresh bar-2 values, maintaining accurate prior state for next-cycle comparison
- **Configurable MA method and price** — `MAMethod` (EMA, SMA, SMMA, LWMA) and `AppliedPrice` (close, open, high, low, median, typical, weighted) independently selectable for any MA style
- **Three notification channels:** sound alert, email, and mobile push
- **Lightweight loop** — polls once per minute (`Sleep(60000)`)

---

## How It Works

1. Every minute, `iMA()` fetches `shortMA` and `longMA` at bar 1; `PrevShortMA` and `PrevLongMA` fetched at bar 2
2. Crossover conditions evaluated:
   - `PrevShortMA <= PrevLongMA && shortMA > longMA` → **Golden Cross Detected**
   - `PrevShortMA >= PrevLongMA && shortMA < longMA` → **Death Cross Detected**
3. `PrevShortMA` and `PrevLongMA` updated at cycle end

---

## Input Parameters

| Parameter        | Type            | Default       | Description                                        |
|------------------|-----------------|---------------|----------------------------------------------------|
| `TradeSymbol`    | string          | `EURUSD`      | Symbol for analysis                                |
| `Timeframe`      | ENUM_TIMEFRAMES | `PERIOD_H1`   | Timeframe for analysis                             |
| `ShortMAPeriod`  | int             | `50`          | Short-term moving average period                   |
| `LongMAPeriod`   | int             | `200`         | Long-term moving average period                    |
| `MAMethod`       | ENUM_MA_METHOD  | `MODE_EMA`    | Moving average calculation method                  |
| `AppliedPrice`   | ENUM_APPLIED_PRICE | `PRICE_CLOSE` | Price series applied to MA calculation          |
| `EnableAlerts`   | bool            | `true`        | Fire an on-screen/sound alert                      |
| `EnableEmail`    | bool            | `false`       | Send an email notification                         |
| `EnablePush`     | bool            | `false`       | Send a mobile push notification                    |

---

## Alert Message Format

```
Golden Cross detected on EURUSD (Timeframe: PERIOD_H1)
Short MA: 1.08420, Long MA: 1.08380
```

---

## Installation

1. Copy `Symbol_Loader_001.mq4` to `MQL4/Scripts/` in your MT4 data folder
2. Compile in MetaEditor (F7)
3. Drag onto any chart from Navigator → Scripts
4. Configure inputs and click **OK**

---

## Requirements

- MetaTrader 4 (`#property strict` compatible build)
- MQL4 compiler (MetaEditor)

---

## License

MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
