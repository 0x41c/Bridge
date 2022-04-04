# Bridge

A Modern Runtime (soon: Modification) Library

## Setup


```
swift package generate-xcodeproj
```

Whenever you need to create/modify a target, please regenerate .xcodeproj file. This is so that you can first of all, get good use of the C module,
access all the files (like modulemaps), and be able to generate a header when you create a file. Finally, whenever you need to add a swift package dependancy,
please do so from within the xcode project and within the Package.swift file. This will allow both the xcodeproj and the package file to cache the dependancies
from whichever format you choose to use.

### Alternatively

You don't want to use the xcodeproject, but it'll still be required to generate the project whenever doing any of the actions described
earlier. The generated header is included below for you:

```
// ===----------------------------------------------------------------------===
//
//  [File]
//  [Target]
//
//  Created by [Your name] on 2022-02-25.
//
// ===----------------------------------------------------------------------===
//
//  Copyright 2022 0x41c
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
// ===----------------------------------------------------------------------===
```

Also, feel free to add your name to the copyright on files that you create. I'm sure you'd like that :D


## What's to come

Towards the completion of the initial goal of becoming a swift runtime modification library, I'll be adding ways to use
this for multiple other purposes as well. We've had basic versions of a swift-class-dump, but I beleive this could step
just a bit further. I'll also be adding some projects located either on this repository or in an organization dedicated
to this repository to show examples.
