# InjectionSiteRotation

A tiny Swift library for apps that log injections (insulin pens, GLP-1 pens and similar): track six body sites and suggest the next one to rotate to.

```swift
import InjectionSiteRotation
let rotation = SiteRotation()                       // abdomen, thighs, upper arms × left/right
let next = rotation.nextSite(history: logs)         // least recently used, prefers a different area and side
let days = rotation.daysSinceUse(history: logs)     // [site: days since last use]
```

- Never-used sites come first, then the least recently used.
- Ties prefer a different body area and side than the last injection.
- Restrict sites with `SiteRotation(enabledSites: [...])`.

Logging and rotation only: this library never recommends or calculates doses. Always follow the instructions that come with the medicine and your healthcare provider.

Made by the team behind [Bluedose](https://bluedoseapp.com/), a private GLP-1 shot tracker for iPhone. Read more about [injection site rotation](https://bluedoseapp.com/features/injection-site-rotation-app/).

MIT License.
