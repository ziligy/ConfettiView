# ConfettiView

A SwiftUI View that emits confetti with shapes, images, and text.

<img src="https://github.com/ziligy/ConfettiView/blob/master/docs/assets/example.gif" alt="SwiftUI ConfettiView by ziligy" width="319" height="690" align="right">

## Installaion


## Use
```swift
struct ContentView: View {

    let confettiView = ConfettiView( confetti: [
                .text("🎉"),
                .text("💪"),
                .shape(.circle),
                .shape(.triangle),
            ])

    var body: some View {
        confettiView
    }
}

```

## Example
See included example.

