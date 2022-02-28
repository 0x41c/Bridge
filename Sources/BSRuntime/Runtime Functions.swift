//
//  Functions.swift
//  
//
//  Created by 0x41c on 2022-01-20.
//

// TODO: Unify the comment lengths
// TODO: Replace Unsafe[Mutable][Raw][Buffer]Pointer with concrete types or `Any` types
// TODO: Improve all the documentation, it's really vague
// TODO: In places applicable, replace `Any.Type` with actual metadata type (for special cases)

///
/// Copies an objective-c block given its pointer, then returns
/// the block back to the caller. This can be used to take a compile
/// time block literal, and elevate it to the runtime by moving it
/// into the heap, or if already there, by incrementing the retain
/// counter.
///
/// - Parameters:
///   - blockPointer: The pointer of the objective-c block.
///
/// - Returns: A pointer to the block passed in
///
@_silgen_name("_Block_copy")
public func _Block_copy(
    _ blockPointer: UnsafeRawPointer
) -> UnsafeRawPointer

///
/// Releases an objective-c block. If the block is in the heap, this
/// will either (1) decrement the retain count and/or (2) free the
/// memory at the location of the block if the retain count is 0.
///
/// - Parameters:
///   - blockPointer: The pointer of the objective-c
///
@_silgen_name("_Block_release")
public func _Block_release(
    _ blockPointer: UnsafeRawPointer
)

/// For `swift_allocObject` (in this version of the function signature)
/// you pass in `UnsafeRawPointer` Once we get all the metadata bridged
/// replace it with `ClassMetadata` or similar type. Also, I'm not sure
/// enough about how the alignment mask works to explain it. If someone
/// feels like documenting it, that would be amazing. (zoomer problem)

///
/// Creates an object of the specified swift class type. This does not
/// take the default size of the type specified in the metadata into
/// account,so size must be specified by the caller. For size
/// independant allocations, use: `swift_allocBox`
///
/// - Parameters:
///   - type: The type of the object to allocate.
///   - size: The size of the object to allocate.
///   - alignMask: The mask used to determine the size of the aligned allocation
///
/// - Returns: A pointer to the semi-initialized object
///
@_silgen_name("swift_allocObject")
public func swift_allocObject(
    _ type: Any.Type,
    _ size: Int,
    _ alignMask: Int
) -> UnsafeRawPointer // HeapObject* (or RefCounted*)

///
/// Creates and returns a structure containing an allocated heap object
/// as well as the value itself following it.
///
/// - Parameters:
///   - type: The type of the heap object to allocate
///
/// - Returns: A pointer to the newly allocated box pair
///
@_silgen_name("swift_allocBox")
public func swift_allocBox(
    _ type: Any.Type
) -> UnsafeRawPointer

// TODO: Document metadata parameters

///
/// Allocates a `ClassMetadata` and returns the new memory.
///
/// This memory is uninitialized, further work is needed to
/// have this properly behave as a type.
///
/// - Parameters:
///   - classDescriptor: The object describing the characteristics
///                      of the class metadata.
///
@_silgen_name("swift_allocateGenericClassMetadata")
public func swift_allocateGenericClassMetadata(
    _ classDescriptor: UnsafeRawPointer,
    _ arguments: UnsafeRawPointer,
    _ pattern: UnsafeRawPointer
) -> UnsafeRawPointer

///
/// Allocate a `GenericValueMetadata` object. This is intended to be
/// called by the metadata instantation function of a generic struct
/// or enum.
///
/// - Parameters:
///   - valueDescriptor: The descriptor determining how the metadata will
///                      be allocated
///   - arguments:
///
@_silgen_name("swift_allocateGenericValueMetadata")
public func swift_allocateGenericValueMetadata(
    _ valueDescriptior: UnsafeRawPointer,
    _ arguments: UnsafeRawPointer,
    _ pattern: UnsafeRawPointer,
    _ extraDataSize: Int
) -> UnsafeRawPointer

///
/// The type `UnsafeRawPointer` in the case of the array function signatures
/// actually represent `OpaqueValue*`. Until That is properly bridged over,
/// it is what it is. `Any.Type` Represents the self parameter or `Metadata`.
/// This follows the same principle. Until the proper Array metadata is bridged,
/// we leave it be. This may not be the best solution so every suggestion
/// is appreciated
///
/// All the array functions are wrapping the singular function `array_copy_operation`.
/// The `array_copy_operation` function acts as one size fits all for all initializing
/// and copying functions for arrays. There are three things that determine the route
/// that it takes to copy values or initialize them from one array to another. These
/// are (1) The destination operation, (2) the source operation, and finally (3) the
/// copy kind. Before explaining what they do, take note that the value passed in as
/// `self` is the `ValueWitnessTable` that will be used for the operations.
///
/// What the destination operation determines is wether the `ValueWitnessTable` will
/// be created  or whether it will be copied into. These are determined by the c++
/// template values `ArrayDest::Init`, and `ArrayDest::Assign` respectively. The source
/// operation determines how the data will be taken from the source object. This can
/// be described with the C++ template types `ArraySource::Copy` and `ArraySource::Take`.
/// Finally, the copy kind determines how the values from the source will be copied into
/// the destination object. This is described with the types `ArrayCopy::NoAlias`,
/// `ArrayCopy::FrontToBack` and `ArrayCopy::BackToFront`. What's interesting about
/// this specifically, is that these will apply to both types of `ValueWitnessTable`
/// and regular POD (Plain Old Data) types, but with functions like `memmove` and
/// `memcopy` in the case of those other types. For the POD types, if the copy kind is
/// `ArrayCopy::NoAlias` the function used is `memcpy` while the other two used `memmove`.
///
/// The functions for this are named in a way that allows you to specify the C++
/// template values. Here's an abstract representation of the initializing functions
/// and the assigning functions:
///
///     `array(Init|Assign)With(Copy|Take)(NoAlias|FrontToBack|BackToFront)(arguments...)`
///
/// the arrayDestroy function does not follow these rules.
///

///
/// Using an already existant array and associated heap object, this
/// assigns values from the source object object to the destination
/// by copying them from the back of the object to the front. When
/// the witness table is POD it uses `memmove` for the memory operation.
/// When not POD, however, it will default to a witness function.
///
/// - C++ Template Values:
///   - `ArrayDest::Assign`
///   - `ArraySource::Copy`
///   - `ArrayCopy::BackToFront`
///
/// - Parameters:
///   - destination: The destination heap object.
///   - source: The source heap object.
///   - count: Amount of items in the source object.
///   - self: The destinations initialized metadata.
///
/// - Note: **This is from pure speculation. Proceed with caution**
///
@_silgen_name("swift_arrayAssignWithCopyBackToFront")
public func swift_arrayAssignWithCopyBackToFront(
    _ destination: UnsafeRawPointer,
    _ source: UnsafeRawPointer,
    _ count: Int,
    _ self: Any.Type
)

///
/// Using an already existant array and associated heap object, this
/// assigns values from the source object to the destination object
/// by copying them from the front of the object to the back. It does
/// this using a `memove` when the witness table is POD, and by using
/// a default witness function when not POD.
///
/// - C++ Template Values:
///   - `ArrayDest::Assign`
///   - `ArraySource::Copy`
///   - `ArrayCopy::FrontToBack`
///
/// - Parameters:
///   - destination: The destination heap object.
///   - source: The source heap object.
///   - count: Amount of items in the source object.
///   - self: The destinations initialized metadata.
///
/// - Note: **This is from pure speculation. Proceed with caution**
///
@_silgen_name("swift_arrayAssignWithCopyFrontToBack")
public func swift_arrayAssignWithCopyFrontToBack(
    _ destination: UnsafeRawPointer,
    _ source: UnsafeRawPointer,
    _ count: Int,
    _ self: Any.Type
)

///
/// Using an already existant array and associated heap object, this
/// assigns values from the source object object to the destination
/// by defaulting to a witness function to copy the values when not
/// POD, but using `memcpy` when it is POD.
///
/// - C++ Template Values:
///   - `ArrayDest::Assign`
///   - `ArraySource::Copy`
///   - `ArrayCopy::NoAlias`
///
/// - Parameters:
///   - destination: The destination heap object.
///   - source: The source heap object.
///   - count: Amount of items in the source object.
///   - self: The destinations initialized metadata.
///
/// - Note: **This is from pure speculation. Proceed with caution**
///
@_silgen_name("swift_arrayAssignWithCopyNoAlias")
public func swift_arrayAssignWithCopyNoAlias(
    _ destination: UnsafeRawPointer,
    _ source: UnsafeRawPointer,
    _ count: Int,
    _ self: Any.Type
)

///
/// Using an already existant array, it destorys a certain amount of
/// values from inside of it. This is done using the destroy function
/// of the arrays witness table function `destroy`. There is no
/// alternative to this so non POD values will not be able to utilize
/// the function.
///
///
/// - Parameters:
///   - begin: The array heap object.
///   - count: Amount of items to destroy in the heap object.
///   - self: The arrays initialized metadata.
///
/// - Note: **This is from pure speculation. Proceed with caution**
///
@_silgen_name("swift_arrayDestroy")
public func swift_arrayDestroy(
    _ begin: UnsafeRawPointer,
    _ count: Int,
    _ self: Any.Type
)

///
/// Taking an empty heap object and an already initialized one, this
/// initializes the empty one by copying a certain amount of children
/// from the initialized one. If the source object is POD, it gets
/// copied using `memcpy`. If not, it utilizes the provided witness
/// functions located in the metadata's witness table.
///
/// - C++ Template Values:
///   - `ArrayDest::Init`
///   - `ArraySource::Copy`
///   - `ArrayCopy::NoAlias`
///
/// - Parameters:
///   - destination: The destination heap object.
///   - source: The source heap object.
///   - count: Amount of items in the source object.
///   - self: The destinations initialized metadata.
///
/// - Note: **This is from pure speculation. Proceed with caution**
///
@_silgen_name("swift_arrayInitWithCopy")
public func swift_arrayInitWithCopy(
    _ destination: UnsafeRawPointer,
    _ source: UnsafeRawPointer,
    _ count: Int,
    _ self: Any.Type
)

///
/// Using an empty heap object and an already existant array, this
/// takes values from the existant one and fills the empty one. If
/// the metadata is POD, this is done `memmove`; else it is done with
/// a witness funcion.
///
/// - C++ Template Values:
///   - `ArrayDest::Assign`
///   - `ArraySource::Copy`
///   - `ArrayCopy::FrontToBack`
///
/// - Parameters:
///   - destination: The destination heap object.
///   - source: The source heap object.
///   - count: Amount of items in the source object.
///   - self: The destinations initialized metadata.
///
/// - Note: **This is from pure speculation. Proceed with caution**
///
@_silgen_name("swift_arrayInitWithTakeBackToFront")
public func swift_initWithTakeBackToFront(
    _ destination: UnsafeRawPointer,
    _ source: UnsafeRawPointer,
    _ count: Int,
    _ self: Any.Type
)

///
/// Using an empty heap object and an already existant array, this
/// takes values from the existant one and fills the empty one. If
/// the metadata is POD, this is done `memmove`; else it is done with
/// a witness funcion.
///
/// - C++ Template Values:
///   - `ArrayDest::Assign`
///   - `ArraySource::Copy`
///   - `ArrayCopy::FrontToBack`
///
/// - Parameters:
///   - destination: The destination heap object.
///   - source: The source heap object.
///   - count: Amount of items in the source object.
///   - self: The destinations initialized metadata.
///
/// - Note: **This is from pure speculation. Proceed with caution**
///
@_silgen_name("swift_arrayInitWithTakeFrontToBack")
public func swift_initWithTakeFrontToBack(
    _ destination: UnsafeRawPointer,
    _ source: UnsafeRawPointer,
    _ count: Int,
    _ self: Any.Type
)

///
/// Using an empty heap object and an already existant array, this
/// takes values from the existant one and fills the empty one. If
/// the metadata is POD, this is done `memcpy`; else it is done with
/// a witness funcion.
///
/// - C++ Template Values:
///   - `ArrayDest::Assign`
///   - `ArraySource::Copy`
///   - `ArrayCopy::FrontToBack`
///
/// - Parameters:
///   - destination: The destination heap object.
///   - source: The source heap object.
///   - count: Amount of items in the source object.
///   - self: The destinations initialized metadata.
///
/// - Note: **This is from pure speculation. Proceed with caution**
///
@_silgen_name("swift_arrayInitWithTakeNoAlias")
public func swift_initWithTakeNoAlias(
    _ destination: UnsafeRawPointer,
    _ source: UnsafeRawPointer,
    _ count: Int,
    _ self: Any.Type
)

///
/// For this section, `UnsafeRawPointer` is in place of `AutoDiffLinearMapContext`;
/// of course, this is here until we exchange the code with the type implementation.
/// I'm thinking that it would be cool to just rewrite the `AutoDiffLinearMapContext`
/// to tail allocate the initial slab. This would cover their TODO and it would be
/// in swift. Two big bonuses.
///

///
/// Allocates the memory needed to create a new subcontext then
/// returns the memory back to the caller. The allocation is handled
/// by the instances allocator.
///
/// - Parameters:
///   - instance: The instance of the `AutoDiffLinearMapContext`
///   - size: The size of the context to allocate memory for.
///
/// - Returns: A pointer to the base of the new memory.
///
@_silgen_name("swift_autoDiffAllocateSubcontext")
public func swift_autoDiffAllocateSubContext(
    _ instance: UnsafeRawPointer,
    _ size: Int
) -> UnsafeRawPointer

///
/// `malloc`'s a buffer suitable for the `AutoDiffLinearMapContext`
/// and returns the initialized memory. The memory passed in increases
/// the allocation internally at the tail.
///
/// - Parameters:
///   - topLevelLinearMapStructSize: The size of the linear map struct
///                                 that will be located at the tail of
///                                 the context.
///
/// - Returns: A pointer to the freshly allocated context.
///
@_silgen_name("swift_autoDiffCreateLinearMapContext")
public func swift_autoDiffCreateLinearMapContext(
    _ topLevelLinearMapStructSize: Int
) -> UnsafeRawPointer

///
/// Calculates and returns the address to the start of the tail-allocated
/// sub-context.
///
/// - Parameters:
///   - instance: The context to retrieve the pointer from.
///
/// - Returns: A pointer to the top-level subcontext.
///
@_silgen_name("swift_autoDiffProjectTopLevelSubcontext")
public func swift_autoDiffProjectTopLevelSubcontext(
    _ instance: UnsafeRawPointer
) -> UnsafeRawPointer

///
/// Starts dynamically tracking accesses to a variable for modification
/// monitoring. This is to ensure the exclusivity rule. Learn more about
/// it here at https://www.swift.org/blog/swift-5-exclusivity/
///
/// This starts monitoring accesses as soon as it returns and will throw
/// a runtime failiure if an incompatible access is underway.
///
/// - Parameters:
///   - variable: A pointer to the object to monitor
///   - valueBuffer: An associated `ValueBuffer` that acts as a tracked
///                  access storage for the pointer.
///   - flags: Some `ExclusivityFlags` that determine the access actions
///            that are allowed on the pointer.
///
@_silgen_name("swift_beginAccess")
public func swift_beginAccess(
    _ variable: Any,
    _ valueBuffer: UnsafeRawPointer,
    _ exclusivityFlags: UnsafeRawPointer
)

///
/// Decrements the strong retain count of a bridged object
/// by one, or frees the memory if there are no longer any
/// retains.
///
/// - Parameters:
///   - value: A bridged object (Any objective-c object).
///
@_silgen_name("swift_bridgeObjectRelease")
public func swift_bridgeObjectRelease(
    _ value: AnyObject
)

///
/// Decrements the strong retain count of a bridged object
/// by `n`, or frees the memory if there are no longer any
/// retains.
///
/// - Parameters:
///   - value: A bridged object (Any objective-c object).
///   - n: The number of retain counts to remove.
@_silgen_name("swift_bridgeObjectRelease_n")
public func swift_bridgeObjectRelease_n(
    _ value: AnyObject,
    _ n: Int32
)

///
/// Increments the retain count of the passed in object by
/// one. Nothing happens to the object if the retain count
/// is zero.
///
/// - Parameters:
///   - value: A bridged object (Any objective-c object).
///
@_silgen_name("swift_bridgeObjectRetain")
public func swift_bridgeObjectRetain(
    _ value: AnyObject
)

///
/// Increments the retain count of the passed in object by
/// `n`. Nothing happens to the object if the retain count
/// is zero.
///
/// - Parameters:
///   - value: A bridged object (Any objective-c object).
///   - n: The amount of retains to add to the count.
///
@_silgen_name("swift_bridgeObjectRetain_n")
public func swift_bridgeObjectRetain_n(
    _ value: AnyObject,
    _ n: Int32
)

///
/// An alias of `swift_bridgeObjectRelease`
///
/// - Parameters:
///   - value: The object to decrement the retain count of
///            and/or free the memory.
///
@_silgen_name("swift_bridgeRelease")
public func swift_bridgeRelease(
    _ value: AnyObject
)

///
/// Wraps and initializes the request object with a structure
/// containing a range of functions available for getting the
/// `MetadataResponse`'s for the required metadata.
///
/// - Parameters:
///   - request: The request to initialize with the struct
///              `CheckStateCallbacks`
///   - type: The type metadata to request the wrapper for.
///
@_silgen_name("swift_checkMetadataState")
public func swift_checkMetadataState(
    _ request: Int,
    _ type: Any.Type
) -> UnsafeRawPointer

#if swift(>=5.4)
///
/// By comparing multiple features of a type descriptor such as pointer
/// equality, being null, uniqueness, kinds, and parents, it determines
/// whether they are the same and/or describe the same type context.
///
/// - Parameters:
///   - firstContextDescriptor: The first context descriptor to compare.
///   - secondContextDescriptor: The second context descriptor to compare.
///
@_silgen_name("swift_compareTypeContextDescriptors")
public func compareTypeContextDescriptors(
    _ firstContextDescriptor: UnsafeRawPointer,
    _ secondContextDescriptor: UnsafeRawPointer
) -> Bool

#endif // swift(>=5.4)

///
/// Checks and determines the protocol conformance of a given type.
///
/// - Parameters:
///   - type: The medata of the type to check the conformance of
///   - protocol: The protocol to check the metadata for conformance of
/// - Returns: Returns true when conforming and false otherwise.
@_silgen_name("swift_conformsToProtocol")
public func swift_conformsToProtocol(
    _ type: Any.Type,
    _ protocol: UnsafeRawPointer
) -> UnsafeRawPointer

// TODO: Invest more time to learn continuation ABI

#if swift(>=5.1)
///
/// Awaits a continuation on the current task until resumed. If it's
/// pending, restore the state to the current task as resumed.
///
/// - Parameters:
///   - continuationContext: The context to check the status of.
///
@_silgen_name("swift_continuation_await")
public func swift_continuation_await(
    _ continuationContext: UnsafeRawPointer
)
#endif // swift(>=5.1))

///
/// Creates an async task around the flags/context and sets the
/// default task values.
///
/// - Parameters:
///   - continuationContext: The context to set the task parent,
///                          resume parent, and normal result of the task.
///   - continuationFlags: The flags to pass to the context.
///
/// - Returns: The new `AsyncTask` created.
///
@_silgen_name("swift_continuation_init")
public func swift_continuation_init(
    _ continuationContext: UnsafeRawPointer,
    _ continuationFlags: UnsafeRawPointer
) -> UnsafeRawPointer

///
/// Resumes an async continuation task that has a non throwing continuation.
///
/// - Parameters:
///   - continuationTask: The task to resume.
///
@_silgen_name("swift_continuation_resume")
public func swift_continuation_resume(
    _ continuationTask: UnsafeRawPointer
)

///
/// Resumes an async continuation task that does have a throwing continuation.
///
/// - Parameters:
///   - continuationTask: The throwing task to resume.
///
@_silgen_name("swift_continuation_throwingResume")
public func swift_continuation_throwingResume(
    _ continuationTask: UnsafeRawPointer
)

///
/// Resumes an async continuation task by throwing an error.
///
/// - Parameters:
///   - continuationTask: The throwing task to resume.
///
@_silgen_name("swift_continuation_throwingResumeWithError")
public func swift_continuation_throwingResumeWithError(
    _ continuationTask: UnsafeRawPointer,
    _ error: Error
)

///
/// Preforms a `memcpy` of the source data into the address of
/// the destination. It gets the size from the `objectType` parameter
/// once it's cast to a metadata type with an attached witness table size.
///
/// - Parameters:
///   - destination: The destination address to copy the data to.
///   - source: The source pointer to copy the memory of into the destination.
///   - objectType: The metadata to get the memory size of.
///
@_silgen_name("swift_copyPOD")
public func swift_copyPOD(
    _ destination: UnsafeRawPointer,
    _ source: UnsafeRawPointer,
    _ objectType: Any.Type
)

// Copying the documentation from the repo here as it explains best

///
/// Deallocate the given memory.
///
/// It must have been returned by `swift_allocObject`, possibly used as an
/// Objective-C class instance, and the strong reference must have the
/// `RC_DEALLOCATING_FLAG` flag set, but otherwise the object is in an unknown
/// state.
///
/// - Parameters:
///   - heapObject: Never nil.
///   - allocatedSize: The allocated size of the object from the.
///                    program's perspective, i.e. the value.
///   - alignMask: The alignment requirement passed to `swift_allocObject.
///
@_silgen_name("swift_deallocClassInstance")
public func swift_deallocClassInstance(
    _ heapObject: UnsafeRawPointer,
    _ allocatedSize: Int,
    _ alignMask: Int
)

///
/// Deallocate the given memory.
///
/// It must have been returned by `swift_allocObject`, possibly used as an
/// Objective-C class instance, and the strong reference must have the
/// `RC_DEALLOCATING_FLAG` flag set, but otherwise the object is in an unknown
/// state.
///
/// - Parameters:
///   - heapObject: Never nil.
///   - allocatedSize: The allocated size of the object from the.
///                    program's perspective, i.e. the value.
///   - alignMask: The alignment requirement passed to `swift_allocObject.
///
@_silgen_name("swift_deallocObject")
public func swift_deallocObject(
    _ heapObject: UnsafeRawPointer,
    _ allocatedSize: Int,
    _ alignMask: Int
)

///
/// Deallocate the given memory after destroying instance variables.
///
/// Destroys instance variables in classes more derived than the given metatype.
///
/// It must have been returned by swift_allocObject, possibly used as an
/// Objective-C class instance, and the strong reference must be equal to 1.
///
/// - Parameters:
///   - heapObject: Never nil.
///   - allocatedSize: The allocated size of the object from the.
///                    program's perspective, i.e. the value.
///   -  alignMask: The alignment requirement passed to `swift_allocObject.
///
@_silgen_name("swift_deallocPartialClassInstance")
public func swift_deallocPartialClassInstance(
    _ heapObject: UnsafeRawPointer
)

///
/// Deallocate an uninitialized object with a strong reference count of +1.
///
/// It must have been returned by swift_allocObject, but otherwise the object is
/// in an unknown state.
///
/// - Parameters:
///   - heapObject: Never nil.
///   - allocatedSize: The allocated size of the object from the.
///                    program's perspective, i.e. the value.
///   - alignMask: The alignment requirement passed to `swift_allocObject.
///
@_silgen_name("swift_deallocUninitializedObject")
public func swift_deallocUninitializedObject(
    _ heapObject: UnsafeRawPointer,
    _ allocatedSize: Int,
    _ allignMask: Int
)

///
/// Deallocates an instance of a default actor.
///
/// - Parameters:
///   - defaultActor: The default actor to deallocate.
///
@_silgen_name("swift_defaultActor_deallocate")
public func swift_defaultActor_deallocate(
    _ defaultActor: UnsafeRawPointer
)

///
/// Deallocate a heap object that might be a default actor.
///
/// Objects that are not default objects get deallocated normally using
/// `swift_deallocObject`.
///
/// - Parameters:
///   - possibleDefaultActor: The heap-object/actor to deallocate.
///
@_silgen_name("swift_defaultActor_deallocateResilient")
public func swift_defaultActor_deallocateResilient(
    _ possibleDefaultActor: UnsafeRawPointer
)

///
/// Destroys a default actor.
///
/// - Parameters:
///   - defaultActor: The default actor to destroy.
///
@_silgen_name("swift_defaultActor_destroy")
public func swift_defaultActor_destroy(
    _ defaultActor: UnsafeRawPointer
)

///
/// Initializes a default actor by calling its initializer.
///
/// - Parameters:
///   - defaultActor: The default actor to initialize.
///
@_silgen_name("swift_defaultActor_initialize")
public func swift_defaultActor_initialize(
    _ defaultActor: UnsafeRawPointer
)

///
/// Crashes when a deleted method is called by accident.
///
/// This function does not return, but aborts instead.
///
@_silgen_name("swift_deletedMethodError")
public func swift_deletedMethodError() -> Never

// FIXME: These are both deprecated, why are they here?
//// void swift_distributedActor_destroy(DefaultActor *actor);
// @_silgen_name("swift_distributedActor_destroy")
//// OpaqueValue* swift_distributedActor_remote_create( OpaqueValue *identity, OpaqueValue *transport);
// @_silgen_name("swift_distributedActor_remote_create")

///
/// Initialize the runtime storage for a distributed remote actor
///
/// - Parameters:
///   - actorType: The type of the remote actor to use for size
///                and alignment checking in the memory initialization.
///
@_silgen_name("swift_distributedActor_remote_initialize")
public func swift_distributedActor_remote_initialize(
    _ actorType: UnsafeRawPointer
)

///
/// Tries to preform a cast on one value type to another with the possibility
/// of failing.
///
/// - Parameters:
///   - destinationLocation: A buffer to write the cast value into. When the
///                          cast fails, this is left uninitialized.
///   - sourceValue: A pointer to the source buffer to cast into the destination.
///                  This may be left uninitialized after the operation, depending
///                  on the flags.
///   - sourceType: The type associated with the source buffer.
///   - destinationType: The type associated with the destination buffer.
///   - flags: Flags controlling how the operation is carried out.
///
/// - Returns: True if the cast succeeded. Depending on the flags,
///   `swift_dynamicCast` may fail rather then return false.
///
@_silgen_name("swift_dynamicCast")
public func swift_dynamicCast(
    _ destinationLocation: UnsafeRawPointer,
    _ sourceValue: UnsafeRawPointer,
    _ sourceType: Any.Type,
    _ destType: Any.Type,
    _ flags: Int
) -> Bool

///
/// Checked dynamic cast to a Swift class type.
///
/// - Parameters:
///   - object: The class object to cast.
///   - targetType: The type to cast the class to.
///
/// - Returns: The object of the cast succeeds, or null otherwise.
///
@_silgen_name("swift_dynamicCastClass")
public func swift_dynamicCastClass(
    _ object: UnsafeRawPointer,
    _ targetType: AnyObject.Type
) -> UnsafeRawPointer?

///
/// Unconditional, checked dynamic cast to a Swift class type.
///
/// Aborts of the object isn't of the target type.
///
/// - Parameters:
///    - object: The object ot cast
///    - targetType: The type to which we are casting, which is known
///                  to be a native swift class type
///    - fileName: The source filename from which to report failure.
///    - lineNumber: The source line from which to report failure.
///    - column: The source column from which to report failure.
///
/// - Returns: The cast object.
///
@_silgen_name("swift_dynamicCastClassUnconditional")
public func swift_dynamicCastClassUnconditional(
    _ object: UnsafeRawPointer,
    _ targetType: AnyObject.Type,
    _ fileName: UnsafePointer<CChar>?,
    _ lineNumber: UInt?,
    _ column: UInt?
) -> UnsafeRawPointer

///
/// Check to determine if a cast will succeed from one type
/// to a metatype.
///
/// The target type should be a superclass of the source type.
///
/// - Parameters:
///   - sourceType: The source type in the validation.
///   - targetType: The type to validate a dynamic cast
///                 from.
///
/// - Returns: The source type if the cast succeeds. If not,
///            a nullptr is returned.
///
@_silgen_name("swift_dynamicCastMetatype")
public func swift_dynamicCastMetatype(
    _ sourceType: Any.Type,
    _ targetType: Any.Type
) -> Any.Type?

///
/// Takes an objective-c class object type and returns the underlying class.
///
/// Static methods can be called from the returned object.
///
/// - Parameters:
///   - metaType: The type of the objective-c object. This
///               should be castable to `NSObject` `AnyObject`.
///
/// - Returns: The objective-c class object of the type
///            or `nullptr` if the type is a native swift type.
///
@_silgen_name("swift_dynamicCastMetatypeToObjectConditional")
public func swift_dynamicCastMetatypeToObjectConditional(
    _ metaType: Any.Type
) -> AnyObject?

///
/// Takes an objective-c class object type and returns the underlying class.
///
/// Static methods can be called from the returned object.
///
/// - Parameters:
///   - metaType: The type of the objective-c object. This is expected
///               to be castable to AnyObject and should inherit from it.
///               If this is not a valid `NSObject`, or `AnyObject` this
///               function will call a dynamicCastFailiure.
///
/// - Returns: The objective-c class object of the type when successful or
///            aborts otherwise
///
@_silgen_name("swift_dynamicCastMetatypeToObjectUnconditional")
public func swift_dynamicCastMetatypeToObjectUnconditional(
    _ metaType: Any.Type
) -> AnyObject

///
/// Check to determine if one type is compatable with another if casted.
///
/// - Parameters:
///   - sourceType: The source type in the validation.
///   - targetType: The type to validate a dynamic cast from.
///   - fileName: The source filename from which to report failure.
///   - lineNumber: The source line from which to report failure.
///   - column: The source column from which to report failure.
///
/// - Returns: The source type if successful or aborts otherwise
///
@_silgen_name("swift_dynamicCastMetatypeUnconditional")
public func swift_dynamicCastMetatypeUnconditional(
    _ sourceType: Any.Type,
    _ targetType: Any.Type,
    _ fileName: UnsafePointer<CChar>?,
    _ lineNumber: UInt?,
    _ columnNumber: UInt?
) -> Any.Type

// TODO: Restrict objc only types

///
/// Checked Objective-C-style dynamic cast to a class type.
///
/// - Parameters:
///   - object: The object to cast into a new type
///   - targetType: The new type to cast the object into
///
/// - Returns: A pointer to the cast object when successful, or
///            nil otherwise.
///
@_silgen_name("swift_dynamicCastObjCClass")
public func swift_dynamicCastObjCClass(
    _ object: UnsafeRawPointer,
    _ targetType: Any.Type
) -> UnsafeRawPointer?

///
/// Check to determine castability from a source type of objective-c origin
/// to a target type also of the same origin.
///
/// - Parameters:
///   - sourceType: The source type to cast into the target type.
///   - targetType: The target type to cast into the source type.
///
/// - Returns: The source type if successful or nil otherwise.
///
@_silgen_name("swift_dynamicCastObjCClassMetatype")
public func swift_dynamicCastObjCClassMetatype(
    _ sourceType: Any.Type,
    _ targetType: Any.Type
) -> UnsafeRawPointer?

///
/// Check to determine castability from a source type of objective-c origin
/// to a target type also of the same origin.
///
/// - Parameters:
///   - sourceType: The source type to cast into the target type.
///   - targetType: The target type to cast into the source type.
///   - fileName: The source filename from which to report failure.
///   - lineNumber: The source line from which to report failure.
///   - column: The source column from which to report failure.
///
/// - Returns: The source type if successful or aborts otherwise.
///
@_silgen_name("swift_dynamicCastObjCClassMetatypeUnconditional")
public func swift_dynamicCastObjCClassMetatypeUnconditional(
    _ sourceType: Any.Type,
    _ targetType: Any.Type,
    _ fileName: UnsafePointer<CChar>?,
    _ lineNumber: UInt?,
    _ columnNumber: UInt?
) -> UnsafeRawPointer

///
/// Checked Objective-C-style dynamic cast to a class type.
///
/// - Parameters:
///   - object: The object to cast into a new type.
///   - targetType: The new type to cast the object into.
///   - fileName: The source filename from which to report failure.
///   - lineNumber: The source line from which to report failure.
///   - column: The source column from which to report failure.
///
/// - Returns: A pointer to the cast object when successful, or
///   aborts otherwise.
///
@_silgen_name("swift_dynamicCastObjCClassUnconditional")
public func swift_dynamicCastObjCClassUnconditional(
    _ object: UnsafeRawPointer,
    _ targetType: Any.Type,
    _ fileName: UnsafePointer<CChar>?,
    _ lineNumber: UInt?,
    _ columnNumber: UInt?
) -> UnsafeRawPointer

///
/// Performs a check to determine if the object conforms the protocol(s).
///
/// - Parameters:
///   - object: The objective-c object to perform the cast on.
///   - protocolCount: The amount of protocols to check conformance of.
///   - protocols: An array of protocols to check conformance of.
///
/// - Returns: The object when successful, or nil otherwise.
///
@_silgen_name("swift_dynamicCastObjCProtocolConditional")
public func swift_dynamicCastObjCProtocolConditional(
    _ object: UnsafeRawPointer,
    _ protocolCount: Int,
    _ protocols: UnsafeRawBufferPointer
) -> UnsafeRawPointer?

///
/// Performs a check to determine if the object conforms the protocol(s).
///
/// - Parameters:
///   - object: The objective-c object to perform the cast on.
///   - protocolCount: The amount of protocols to check conformance of.
///   - protocols: An array of protocols to check conformance of.
///   - fileName: The source filename from which to report failure.
///   - lineNumber: The source line from which to report failure.
///   - column: The source column from which to report failure.
///
/// - Returns: The object when successful, or aborts otherwise.
///
@_silgen_name("swift_dynamicCastObjCProtocolUnconditional")
public func swift_dynamicCastObjCProtocolUnconditional(
    _ object: UnsafeRawPointer,
    _ protocolCount: Int,
    _ protocols: UnsafeRawBufferPointer,
    _ fileName: UnsafePointer<CChar>?,
    _ lineNumber: UInt?,
    _ columnNumber: UInt?
) -> UnsafeRawPointer

///
/// Performs a check to determine if the type conforms the protocol(s).
///
/// - Parameters:
///   - type: The objective-c type to perform the cast on.
///   - protocolCount: The amount of protocols to check conformance of.
///   - protocols: An array of protocols to check conformance of.
///
/// - Returns: The type when successful, or nil otherwise.
///
@_silgen_name("swift_dynamicCastTypeToObjCProtocolConditional")
public func swift_dynamicCastTypeToObjCProtocolConditional(
    _ type: Any.Type,
    _ protocolCount: Int,
    _ protocols: UnsafeRawBufferPointer
) -> Any.Type?

///
/// Performs a check to determine if the type conforms the protocol(s).
///
/// - Parameters:
///   - object: The objective-c type to perform the cast on.
///   - protocolCount: The amount of protocols to check conformance of.
///   - protocols: An array of protocols to check conformance of.
///   - fileName: The source filename from which to report failure.
///   - lineNumber: The source line from which to report failure.
///   - column: The source column from which to report failure.
///
/// - Returns: The type when successful, or aborts otherwise.
///
@_silgen_name("swift_dynamicCastTypeToObjCProtocolUnconditional")
public func swift_dynamicCastTypeToObjCProtocolUnconditional(
    _ type: Any.Type,
    _ protocolCount: Int,
    _ protocols: UnsafeRawBufferPointer,
    _ fileName: UnsafePointer<CChar>?,
    _ lineNumber: UInt?,
    _ columnNumber: UInt?
) -> Any.Type?

///
/// Checked dynamic cast of a class instance pointer to the given type.
///
/// - Parameters:
///   - object: The class instance to cast.
///   - targetType: The type to cast the class to
///
/// - Returns: The class instance if successful, and nil otherwise.
///
@_silgen_name("swift_dynamicCastUnknownClass")
public func swift_dynamicCastUnknownClass(
    _ object: UnsafeRawPointer,
    _ targetType: Any.Type
) -> UnsafeRawPointer?

///
/// Checked dynamic cast of a class instance pointer to the given type.
///
/// - Parameters:
///   - object: The class instance to cast.
///   - targetType: The type to cast the class to.
///   - fileName: The source filename from which to report failure.
///   - lineNumber: The source line from which to report failure.
///   - column: The source column from which to report failure.
///
/// - Returns: The class instance if successful, or aborts otherwise.
///
@_silgen_name("swift_dynamicCastUnknownClassUnconditional")
public func swift_dynamicCastUnknownClassUnconditional(
    _ object: UnsafeRawPointer,
    _ targetType: Any.Type,
    _ fileName: UnsafePointer<CChar>?,
    _ lineNumber: UInt?,
    _ columnNumber: UInt?
) -> UnsafeRawPointer

///
/// Stop dynamically tracking an access
///
/// - Parameters:
///   - access: An associated `ValueBuffer` that acts as a tracked
///     access storage for the pointer.
///
@_silgen_name("swift_endAccess")
public func swift_endAccess(
    _ access: UnsafeRawPointer
)

///
/// Invoked by the compiler when code at top level throws
/// an error.
///
/// - Parameters:
///   - error: The error thrown/to throw.
///
@_silgen_name("swift_errorInMain")
public func swift_errorInMain(
    _ error: Error
) -> Never

///
/// Decrements or deallocates the error object depending on
/// the strong retain count.
///
/// - Parameters:
///   - error: The error to release.
///
@_silgen_name("swift_errorRelease")
public func swift_errorRelease(
    _ error: Error
)

///
/// Increments the strong retain count of the error object.
///
/// - Parameters:
///   - error: The error to retain.
///
/// - Returns: The retained error object.
///
@_silgen_name("swift_errorRetain")
public func swift_errorRetain(
    _ error: Error
) -> Error

// TODO: Better documentation here

///
/// Retrieve an associated conformance witness table from the
/// given witness table.
///
/// - Parameters:
///   - witnessTable: The witness table.
///   - conformingType: Metadata for the conforming type.
///   - associatedType: Metadata for the associated type.
///   - requirementBase: "Base" requirement used to compute the witness index.
///   - associatedConformance: Associated conformance descriptor.
///
/// - Returns: The corresponding witness table.
///
@_silgen_name("swift_getAssociatedConformanceWitness")
public func swift_getAssociatedConformanceWitness(
    _ witnessTable: UnsafeRawPointer,
    _ conformingType: Any.Type,
    _ associatedType: Any.Type,
    _ requirementBase: UnsafeRawPointer,
    _ associatedConformance: UnsafeRawPointer
) -> UnsafeRawPointer

///
/// Retrieve an associated type witness from the given witness table.
///
/// - Parameters:
///   - request: A specification of the metadata to be returned.
///   - witnessTable: The witness table.
///   - conformingType: Metadata for the conforming type.
///   - requirementBase: "Base" requirement used to compute the witness index.
///   - associatedType: Associated type descriptor.
///
/// - Returns: Metadata for the associated type witness.
///
@_silgen_name("swift_getAssociatedTypeWitness")
public func swift_getAssociatedTypeWitness(
    _ request: Int,
    _ witnessTable: UnsafeRawPointer,
    _ conformingType: Any.Type,
    _ requirementBase: UnsafeRawPointer,
    _ associatedType: UnsafeRawPointer
) -> UnsafeRawPointer

#if swift(>=5.4)

///
/// Fetch a uniqued metadata object for the generic nominal type described by
/// the provided description and arguments, adding the canonical
/// prespecializations attached to the type descriptor to the metadata cache on
/// first run.
///
/// In contrast to swift_getGenericMetadata, this function is for use by
/// metadata accessors for which canonical generic metadata has been specialized
/// at compile time.
///
/// - Parameters:
///   - request: A specification of the metadata to be returned.
///   - arguments: The generic arguments--metadata and witness tables--which
///                which the returned metadata is to have been instantiated with.
///   - description: The type descriptor for the generic type whose generic
///                  metadata is to have been.
///   - token: The token that ensures the prespecialized records are addet to
///            the metadata cache only once.
///
/// - Returns: The canonical metadata for the specialized generic type described
///            by the provided candidate metadata.
///
@_silgen_name("swift_getCanonicalPrespecializedGenericMetadata")
public func swift_getCanonicalPrespecializedGenericMetadata(
    _ request: Int,
    _ arguments: UnsafeRawBufferPointer,
    _ description: UnsafeRawPointer,
    _ token: UnsafeRawPointer
) -> UnsafeRawPointer

///
/// Fetch a uniqued metadata object for the generic nominal type described by
/// the provided candidate metadata, using that candidate metadata if there is
/// not already a canonical metadata.
///
/// - Parameters:
///   - request: A specification of the metadata to be returned.
///   - candidate: A prespecialized metadata record foa type which is not
///                statically made to be canonical which will be canonicalized
///                if no other canonical metadata exists for the type.
///   - cache: A pointer to a cache which will be set to the canonical metadata
///            record for the type described by the candidate metadata record.
///            If the cache has already been populated, its content will be returned.
///
/// - Returns: The canonical metadata for the specialized generic type described
///            by the provided candidate metadata.
///
@_silgen_name("swift_getCanonicalSpecializedMetadata")
public func swift_getCanonicalSpecializedMetadata(
    _ request: Int,
    _ candidate: Any.Type,
    _ cache: UnsafePointer<Any.Type>
) -> UnsafeRawPointer

#endif // swift(>=5.4)

///
/// Get the dynamic type of an opaque value.
///
/// - Parameters:
///   - value: An opaque value
///   - type: The static type metadata for the opaque value and the result
///           type value.
///   - existentialMetatype: Whether the result type value is an existential
///                          metatype. If `type` is an existential type,
///                          then a `false` value indicates that the result
///                          is of concrete metatype type `type.Protocol`,
///                          and existential containers will not be projected
///                          through. A `true` value indicates that the result
///                          is of existential metatype type `type.Type`,
///                          so existential containers can be projected
///                          through as long as a subtype relationship holds
///                          from `type` to the contained dynamic type.
///
/// - Returns: The dynamic type of provided `value`.
///
@_silgen_name("swift_getDynamicType")
public func swift_getDynamicType(
    _ value: Any,
    _ type: Any.Type,
    _ existentialMetatype: Bool // This tells the function which one it is
) -> Any.Type?

///
/// Returns an integer value representing which case of a multi-payload
/// enum is inhabited.
///
/// - Parameters:
///   - value: A pointer to the enum value.
///   - enumType: Type metadata for the enum.
///
/// - Returns: The index of the enum case.
///
@_silgen_name("swift_getEnumCaseMultiPayload")
public func swift_getEnumCaseMultiPayload(
    _ value: UnsafeRawPointer,
    _ enumType: Any.Type
) -> UInt

public typealias getExtraInhabitantTag_t = @convention(c) (
    _ value: UnsafeRawPointer,
    _ numExtraInhabitants: UInt,
    _ payloadType: UnsafeRawPointer
) -> UInt

///
/// Implement `getEnumTagSinglePayload` generically in terms of a
/// payload type with a `getExtraInhabitantIndex` function.
///
/// - Parameters:
///   - value: Pointer to the enum value.
///   - emptyCasesCount: The number of empty cases in the enum.
///   - payloadType: Type metadata for the payload case of the enum.
///
/// - Returns: `0` if the payload case is inhabited. If an empty case
///            is inhabited, it returns a value greater than or equal to
///            `1` and less than or equal to `emptyCasesCount`
///
@_silgen_name("swift_getEnumTagSinglePayloadGeneric")
public func swift_getEnumTagSinglePayloadGeneric(
    _ value: UnsafeRawPointer,
    _ emptyCasesCount: UInt,
    _ payloadType: Any.Type,
    _ getExtraInhabitantIndex_ptr: getExtraInhabitantTag_t
) -> UInt

///
/// Fetch a uniqued metadata for an existential metatype type.
///
/// - Parameters:
///   - instanceType: The type to get the existential metatype type
///                   from.
///
/// - Returns: A uniqued metadata for an existential metatype type.
///
@_silgen_name("swift_getExistentialMetatypeMetadata")
public func swift_getExistentialMetatypeMetadata(
    _ instanceType: Any.Type
) -> Any.Type

///
/// Fetch a uniqued metadata for an existential type.
///
/// The array referenced by `protocols` will be sorted in-place.
///
/// - Parameters:
///   - classConstraint: Defines whether the type is a class or not.
///   - superClassConstraint: The type of the super class if any.
///   - protocolCount: The amount of protocols the type conforms to.
///   - protocols: A buffer pointer containing the protocol references.
///
/// - Returns: `AnyObject` or `Any` if there is no superclass and no protocols.
///            Otherwise, it will return a type from a lookup table with all the
///            parameters used as a key.
@_silgen_name("swift_getExistentialTypeMetadata")
public func swift_getExistentialTypeMetadata(
    _ classConstraint: UnsafeRawPointer,
    _ superClassConstraint: Any.Type?,
    _ protocolCount: Int,
    _ protocols: UnsafeRawBufferPointer
) -> Any.Type

///
/// Fetch a unique type metadata object for a foreign type.
///
/// - Parameters:
///   - foreignType: The type to get the unique counterpart of.
///
/// - Returns: A unique type metadata object.
///
@_silgen_name("swift_getForeignTypeMetadata")
public func swift_getForeignTypeMetadata(
    _ foreignType: Any.Type
) -> Any.Type

//// Metadata *swift_getFunctionTypeMetadata(unsigned long flags, const Metadata **parameters, const uint32_t *parameterFlags, const Metadata *result);
@_silgen_name("swift_getFunctionTypeMetadata")
public func swift_getFunctionTypeMetadata(
    _ flags: UInt32,
    _ parameters: UnsafeBufferPointer<UnsafeRawPointer>,
    _ porameterFlags: UInt32,
    _ result: Any.Type
) -> Any.Type

//// Metadata *swift_getFunctionTypeMetadata0(unsigned long flags, const Metadata *resultMetadata);
// @_silgen_name("swift_getFunctionTypeMetadata0")

//// Metadata *swift_getFunctionTypeMetadata1(unsigned long flags, const Metadata *arg0, const Metadata *resultMetadata);
// @_silgen_name("swift_getFunctionTypeMetadata1")

//// Metadata *swift_getFunctionTypeMetadata2(unsigned long flags, const Metadata *arg0, const Metadata *arg1, const Metadata *resultMetadata);
// @_silgen_name("swift_getFunctionTypeMetadata2")

//// Metadata *swift_getFunctionTypeMetadata3(unsigned long flags, const Metadata *arg0, const Metadata *arg1, const Metadata *arg2, const Metadata *resultMetadata);
// @_silgen_name("swift_getFunctionTypeMetadata3")

//// Metadata * swift_getFunctionTypeMetadataDifferentiable(unsigned long flags, unsigned long diffKind, const Metadata **parameters, const uint32_t *parameterFlags, const Metadata *result);
// @_silgen_name("swift_getFunctionTypeMetadataDifferentiable")

//// Metadata * swift_getFunctionTypeMetadataGlobalActor(unsigned long flags, unsigned long diffKind, const Metadata **parameters, const uint32_t *parameterFlags, const Metadata *result, const Metadata *globalActor);
// @_silgen_name("swift_getFunctionTypeMetadataGlobalActor")

//// MetadataResponse swift_getGenericMetadata(MetadataRequest request, const void * const *arguments, TypeContextDescriptor *type);
// @_silgen_name("swift_getGenericMetadata")

//// Metadata *swift_getMetatypeMetadata(Metadata *instanceTy);
// @_silgen_name("swift_getMetatypeMetadata")

//// unsigned swift_getMultiPayloadEnumTagSinglePayload(const OpaqueValue *value, uint32_t numExtraCases, const Metadata *enumType)
// @_silgen_name("swift_getMultiPayloadEnumTagSinglePayload")

//// Metadata *swift_getObjCClassFromMetadata(objc_class *theClass);
// @_silgen_name("swift_getObjCClassFromMetadata")

//// Metadata *swift_getObjCClassFromObject(id object);
// @_silgen_name("swift_getObjCClassFromObjde ct")

//// Metadata *swift_getObjCClassMetadata(objc_class *theClass);
// @_silgen_name("swift_getObjCClassMetadata")

//// Metadata *swift_getObjectType(id object);
// @_silgen_name("swift_getObjectType")

//// const WitnessTable *swift_getOpaqueTypeConformance(const void * const *arguments, const OpaqueTypeDescriptor *descriptor, uintptr_t index);
// @_silgen_name("swift_getOpaqueTypeConformance")

//// MetadataResponse swift_getOpaqueTypeMetadata(MetadataRequest request, const void * const *arguments, const OpaqueTypeDescriptor *descriptor, uintptr_t index);
// @_silgen_name("swift_getOpaqueTypeMetadata")

//// MetadataResponse swift_getSingletonMetadata(MetadataRequest request, TypeContextDescriptor *type);
// @_silgen_name("swift_getSingletonMetadata")

//// void swift_getTupleTypeLayout(TypeLayout *result, uint32_t offsets, TupleTypeFlags flags, const TypeLayout * const *elts);
// @_silgen_name("swift_getTupleTypeLayout")

//// Int swift_getTupleTypeLayout2(TypeLayout *layout, const TypeLayout *elt0, const TypeLayout *elt1);
// @_silgen_name("swift_getTupleTypeLayout2")

//// OffsetPair swift_getTupleTypeLayout3(TypeLayout *layout, const TypeLayout *elt0, const TypeLayout *elt1, const TypeLayout *elt2);
// @_silgen_name("swift_getTupleTypeLayout3")

//// MetadataResponse swift_getTupleTypeMetadata(MetadataRequest request, TupleTypeFlags flags, Metadata * const *elts, const char *labels, value_witness_table_t *proposed);
// @_silgen_name("swift_getTupleTypeMetadata")

//// MetadataResponse swift_getTupleTypeMetadata2(MetadataRequest request, Metadata *elt0, Metadata *elt1, const char *labels, value_witness_table_t *proposed);
// @_silgen_name("swift_getTupleTypeMetadata2")

//// MetadataResponse swift_getTupleTypeMetadata3(MetadataRequest request, Metadata *elt0, Metadata *elt1, Metadata *elt2, const char *labels, value_witness_table_t *proposed);
// @_silgen_name("swift_getTupleTypeMetadata3")

//// const Metadata *swift_getTypeByMangledNameInContext( const char *typeNameStart, Int typeNameLength, const TargetContextDescriptor<InProcess> *context, const void * const *genericArgs)
// @_silgen_name("swift_getTypeByMangledNameInContext")

//// const Metadata *swift_getTypeByMangledNameInContextInMetadataState( Int metadataState, const char *typeNameStart, Int typeNameLength, const TargetContextDescriptor<InProcess> *context, const void * const *genericArgs)
// @_silgen_name("swift_getTypeByMangledNameInContextInMetadataState")

//// const ProtocolWitnessTable * swift_getWitnessTable(const ProtocolConformanceDescriptor *conf, const Metadata *type, const void * const *instantiationArgs);
// @_silgen_name("swift_getWitnessTable")

//// void swift_initClassMetadata(Metadata *self, ClassLayoutFlags flags, Int numFields, TypeLayout * const *fieldTypes, Int *fieldOffsets);
// @_silgen_name("swift_initClassMetadata")

//// MetadataDependency swift_initClassMetadata2(Metadata *self, ClassLayoutFlags flags, Int numFields, TypeLayout * const *fieldTypes, Int *fieldOffsets);
// @_silgen_name("swift_initClassMetadata2")

//// void swift_initEnumMetadataMultiPayload(Metadata *enumType, Int numPayloads, TypeLayout * const *payloadTypes);
// @_silgen_name("swift_initEnumMetadataMultiPayload")

//// void swift_initEnumMetadataSingleCase(Metadata *enumType, EnumLayoutFlags flags, TypeLayout *payload);
// @_silgen_name("swift_initEnumMetadataSingleCase")

//// void swift_initEnumMetadataSinglePayload(Metadata *enumType, EnumLayoutFlags flags, TypeLayout *payload, unsigned num_empty_cases);
// @_silgen_name("swift_initEnumMetadataSinglePayload")

//// HeapObject *swift_initStackObject(HeapMetadata const *metadata, HeapObject *object);
// @_silgen_name("swift_initStackObject")

//// HeapObject *swift_initStaticObject(HeapMetadata const *metadata, HeapObject *object);
// @_silgen_name("swift_initStaticObject")

//// void swift_initStructMetadata(Metadata *structType, StructLayoutFlags flags, Int numFields, TypeLayout * const *fieldTypes, uint32_t *fieldOffsets);
// @_silgen_name("swift_initStructMetadata")

///
/// Determines whether the provided type is a class type.
///
/// - Parameters:
///   - type: The type to perform the check on.
///
/// - Returns: True if `type` is a class  type, and false otherwise.
///
@_silgen_name("swift_isClassType")
func swift_isClassType(
    _ type: Any.Type
) -> Bool

//// bool swift_isDeallocating(void *ptr);
// @_silgen_name("swift_isDeallocating")

//// bool swift_isEscapingClosureAtFileLocation(const struct HeapObject *object, const unsigned char *filename, int32_t filenameLength, int32_t line, int32_t col, unsigned type);
// @_silgen_name("swift_isEscapingClosureAtFileLocation")

//// bool swift_isOptionalType(type*);
// @_silgen_name("swift_isOptionalType")

//// bool swift_isUniquelyReferencedNonObjC(const void *);
// @_silgen_name("swift_isUniquelyReferencedNonObjC")

//// bool swift_isUniquelyReferencedNonObjC_nonNull(const void *);
// @_silgen_name("swift_isUniquelyReferencedNonObjC_nonNull")

//// bool swift_isUniquelyReferencedNonObjC_nonNull_bridgeObject( uintptr_t bits);
// @_silgen_name("swift_isUniquelyReferencedNonObjC_nonNull_bridgeObject")

//// bool swift_isUniquelyReferenced_native(const struct HeapObject *);
// @_silgen_name("swift_isUniquelyReferenced_native")

//// bool swift_isUniquelyReferenced_nonNull_native(const struct HeapObject *);
// @_silgen_name("swift_isUniquelyReferenced_nonNull_native")

//// void *swift_lookUpClassMethod(Metadata *metadata, ClassDescriptor *description, MethodDescriptor *method);
// @_silgen_name("swift_lookUpClassMethod")

//// BoxPair swift_makeBoxUnique(OpaqueValue *buffer, Metadata *type, Int alignMask);
// @_silgen_name("swift_makeBoxUnique")

//// void swift_nonatomic_bridgeObjectRelease_n(void *ptr, int32_t n);
// @_silgen_name("swift_nonatomic_bridgeObjectRelease_n")

//// void *swift_nonatomic_bridgeObjectRetain(void *ptr);
// @_silgen_name("swift_nonatomic_bridgeObjectRetain")

//// void swift_nonatomic_bridgeObjectRetain_n(void *ptr, int32_t n);
// @_silgen_name("swift_nonatomic_bridgeObjectRetain_n")

//// void swift_nonatomic_bridgeRelease(void *ptr);
// @_silgen_name("swift_nonatomic_bridgeRelease")

//// void swift_nonatomic_release(void *ptr);
// @_silgen_name("swift_nonatomic_release")

//// void swift_nonatomic_release_n(void *ptr, int32_t n);
// @_silgen_name("swift_nonatomic_release_n")

//// void *swift_nonatomic_retain(void *ptr);
// @_silgen_name("swift_nonatomic_retain")

//// void *swift_nonatomic_retain_n(void *ptr, int32_t n);
// @_silgen_name("swift_nonatomic_retain_n")

//// void swift_nonatomic_unknownObjectRelease(void *ptr);
// @_silgen_name("swift_nonatomic_unknownObjectRelease")

//// void swift_nonatomic_unknownObjectRelease_n(void *ptr, int32_t n);
// @_silgen_name("swift_nonatomic_unknownObjectRelease_n")

//// void *swift_nonatomic_unknownObjectRetain(void *ptr);
// @_silgen_name("swift_nonatomic_unknownObjectRetain")

//// void *swift_nonatomic_unknownObjectRetain_n(void *ptr, int32_t n);
// @_silgen_name("swift_nonatomic_unknownObjectRetain_n")

//// void swift_objc_swift3ImplicitObjCEntrypoint(id self, SEL selector) float swift_intToFloat32(const Int *data, IntegerLiteralFlags flags);
// @_silgen_name("swift_objc_swift3ImplicitObjCEntrypoint")

//// void swift_once(swift_once_t *predicate, void (*function_code)(RefCounted*), void *context);
// @_silgen_name("swift_once")

//// void swift_registerProtocolConformances(const ProtocolConformanceRecord *begin, const ProtocolConformanceRecord *end)
// @_silgen_name("swift_registerProtocolConformances")

//// void swift_registerProtocols(const ProtocolRecord *begin, const ProtocolRecord *end)
// @_silgen_name("swift_registerProtocols")

//// void swift_release(void *ptr);
// @_silgen_name("swift_release")

//// void *swift_release_n(void *ptr, int32_t n);
// @_silgen_name("swift_release_n")

//// Metadata *swift_relocateClassMetadata(TypeContextDescriptor *descriptor, const void *pattern);
// @_silgen_name("swift_relocateClassMetadata")

//// void *swift_retain(void *ptr);
// @_silgen_name("swift_retain")

//// void *swift_retain_n(void *ptr, int32_t n);
// @_silgen_name("swift_retain_n")

//// void swift_setDeallocating(void *ptr);
// @_silgen_name("swift_setDeallocating")

//// void *swift_slowAlloc(Int size, Int alignMask);
// @_silgen_name("swift_slowAlloc")

//// void swift_slowDealloc(void *ptr, Int size, Int alignMask);
// @_silgen_name("swift_slowDealloc")

//// void swift_storeEnumTagMultiPayload(opaque_t *obj, Metadata *enumTy, int case_index);
// @_silgen_name("swift_storeEnumTagMultiPayload")

//// void swift_storeEnumTagSinglePayloadGeneric(opaque_t *obj, unsigned case_index, unsigned num_empty_cases, Metadata *payloadType, void (*storeExtraInhabitant)(opaque_t *obj, unsigned case_index, unsigned numPayloadXI, Metadata *payload));
// @_silgen_name("swift_storeEnumTagSinglePayloadGeneric")

//// void swift_storeMultiPayloadEnumTagSinglePayload(OpaqueValue *value, uint32_t index, uint32_t numExtraCases, const Metadata *enumType);
// @_silgen_name("swift_storeMultiPayloadEnumTagSinglePayload")

//// void swift_taskGroup_destroy(TaskGroup *group);
// @_silgen_name("swift_taskGroup_destroy")

//// void swift_taskGroup_initialize(TaskGroup *group);
// @_silgen_name("swift_taskGroup_initialize")

//// void swift_task_cancel(AsyncTask *task);
// @_silgen_name("swift_task_cancel")

//// AsyncTaskAndContext swift_task_create( Int taskCreateFlags, TaskOptionRecord *options, const Metadata *futureResultType, void *closureEntry, HeapObject *closureContext);
// @_silgen_name("swift_task_create")

//// void swift_task_dealloc(void *ptr);
// @_silgen_name("swift_task_dealloc")

//// AsyncTask *swift_task_getCurrent();s void *swift_task_alloc(Int size);
// @_silgen_name("swift_task_getCurrent")

//// ExecutorRef swift_task_getCurrentExecutor();
// @_silgen_name("swift_task_getCurrentExecutor")

//// ExecutorRef swift_task_getMainExecutor();
// @_silgen_name("swift_task_getMainExecutor")

//// void swift_task_switch(AsyncContext *resumeContext, TaskContinuationFunction *resumeFunction, ExecutorRef newExecutor);
// @_silgen_name("swift_task_switch")

//// void *swift_tryRetain(void *ptr);
// @_silgen_name("swift_tryRetain")

//// void swift_unexpectedError(error *ptr);
// @_silgen_name("swift_unexpectedError")

//// void swift_unknownObjectRelease(void *ptr);
// @_silgen_name("swift_unknownObjectRelease")

//// void swift_unknownObjectRelease_n(void *ptr, int32_t n);
// @_silgen_name("swift_unknownObjectRelease_n")

//// void *swift_unknownObjectRetain(void *ptr);
// @_silgen_name("swift_unknownObjectRetain")

//// void *swift_unknownObjectRetain_n(void *ptr, int32_t n);
// @_silgen_name("swift_unknownObjectRetain_n")

//// void swift_updateClassMetadata(Metadata *self, ClassLayoutFlags flags, Int numFields, TypeLayout * const *fieldTypes, Int *fieldOffsets);
// @_silgen_name("swift_updateClassMetadata")

//// MetadataDependency swift_updateClassMetadata2(Metadata *self, ClassLayoutFlags flags, Int numFields, TypeLayout * const *fieldTypes, Int *fieldOffsets);
// @_silgen_name("swift_updateClassMetadata2")

//// void swift_verifyEndOfLifetime(HeapObject *object);
// @_silgen_name("swift_verifyEndOfLifetime")

//// void swift_willThrow(error *ptr);
// @_silgen_name("swift_willThrow")
