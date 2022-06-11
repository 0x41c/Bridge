
<img src="./Resources/Bridge%20Banner%20Readme.png" align="center"/>

<center>
    <h1>A Modern Runtime Reflection Library</h1>
</center>

### Mission

Our mission here is to provide an articulate runtime interface for swift users. This encompasses more than simply reflecting the metadata swift programs have, but also allowing it to be created and modified during execution.
This will allow a paradigm shift from swift being a mainly statically typed language to being more of a semi-dynamic typed language. This could also alternatively be used to create other languages that derive from the swift
runtime interface directly. Our goal is to provide that as simply and as easily as possible. For developers of other languages, this also benefits you. We'll be incorporating interop features into this library which will allow
you to access the swift runtime from your language of choice. With C++ interoperability in the works, we're sure developers of all technical backgrounds will have fun using this library to further increase the scope in which
swift operates.

## Current Library Scope

Currently, this library is under active development and polishing to encourage open-source contributions from the swift community. Current working features of the library make it an in-beta reflection library.

This list will be updated as the scope changes:

- [x] Complete metadata reflection
- [x] Metadata modification (The way this is built, it already partially has support)
- [ ] Metadata creation

- [ ] Objective-C interface for Reflection
- [ ] Objective-C interface for Modification
- [ ] Objective-C interface for Creation

The following will be considered when C++ interop is out of early phases and is no longer experimental

> - [ ] C++ interface for Reflection
> - [ ] C++ interface for Modification
> - [ ] C++ interface for Creation

There is a slight possibility that with enough cooperation, other runtimes will be added to this library to make it the complete runtime package. Objective-C metadata is partially implemented by sheer inheritance within the swift metadata
ABI, but that will need to be expanded accordingly to properly have it integrated. When that happens, there will be separate lists for runtime features supported by the library for each runtime.

## Walkthrough

Fundamentally, there are a few core protocols that delegate most of the internal functionality of the library. These are used with code that needs special write restrictions that are in between a let, and a var essentially. At the
root of these is a dynamic lookup protocol that allows the get and set of any struct's properties as if it were a keyed dictionary. The only limitation is computed properties, those lack metadata for keypaths, but we're considering
a workaround for that. 

The protocols are [AnyRuntimeModifiable](wiki/AnyRuntimeModifiable) and [RuntimeModifiable](wiki/RuntimeModifiable). The latter inherits from the former. Understanding how these work will help you understand the rest of the codebase.


### Class Metadata

This is most likely the first thing you'll want to try out. We'll start with setting up our class:

```swift
class OurClass {}
```

This is an empty class, and it's likely the first thing you wrote in swift. Do you think it inherits from anything? Looking briefly at the definition, no, it wouldn't seem that way, but this is where the usefulness of a runtime library comes
into play. Let's get its metadata.

To do that we're going to use a nifty struct called [ClassMetadata](wiki/ClassMetadata). If you take a look at the documentation, you'll notice there's a variable called `superclass`. This variable represents the direct ancestor of the class
we choose to peer into. How about we peer into `OurClass` and see if we can confirm it's not inheriting anything.

```swift
let metadata = ClassMetadata(type: OurClass.self)
```

Here we pass in the type to the ClassMetadata structure. What it does is re-cast the type into an [InternalStructureBase](wiki/InternalStructureBase.md). This structure contains all the fields that are present in the metadata and represents them
in an accessible form. By reading from this representation, we can see what exists under the hood of our types.

Let's see what the `superclass` variable has to say about `OurClass`...

```swift
print(metadata.superclass) // Optional(_TtCs12_SwiftObject)
```

Looking at this for the first time, you might be wondering what that is. That is the object that allows swift objects to be compatible with Objective-C. Isn't that interesting! You can look at it's interface here: [SwiftObject.h](https://github.com/apple/swift/blob/main/stdlib/public/runtime/SwiftObject.h).
So it looks like our mystery is solved. We now know that even classes that do not seem to be directly inheriting anything are indirectly inheriting from this mysterious `_TtCs12_SwiftObject`.

### Moving forward

That is only the tip of the iceberg, there is so much more you can do with this metadata, so feel free to look around the documentation. There are improvements that will be made to improve its clarity and understandability.

## Contributing

Will add that soon, don't worry.

## Credits

- [Azoy](https://github.com/Azoy) an amazing runtime engineer and the creator of [Echo](https://github.com/Azoy/Echo).
- [Wickwirew](https://github.com/wickwirew). Another great developer and the creator of [Runtime](https://github.com/wickwirew/Runtime).
- [The Swift Community](https://forums.swift.org). Acknowledging everyone who has contributed to swift and has made it the language it is today.

