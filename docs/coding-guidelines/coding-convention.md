---
layout: default
title: Coding Convention
---
[ Home Page ]({{site.baseurl}}/index) <br>

# Coding Convention[](#top)

* [Guidelines](#guidelines)
* [Avoid Tight Coupling](#avoidTightCoupling)
* [Type Casting](#typeCasting)
* [Classes](#classes)
  * [Compulsory Member Functions](#compulsoryMemberFunctions)
  * [Class Types](#classTypes)
  * [Access Rights](#accessRight)
  * [Constructors](#constructors)
  * [Destructors](#destructors)
  * [Methods](#methods)
  * [Inline Member Functions](#inlineMemberFunctions)

## [](#guidelines)Guidelines

Here's a few pragmatic programmer guidelines to follow:

* **Care About the Software, Care about your API users and end users**  
  Why spend your life developing software unless you care about doing it well? Turn off the autopilot and take control. Constantly critique and appraise your work.
* **Don't Live with Broken Windows**  
  Fix bad designs, wrong decisions, and poor code when you see them. You can't force change on people. Instead, show them how the future might be and help them participate in creating it.
* **Remember the Big Picture**  
  Don't get so engrossed in the details that you forget to check what's happening around you.
* **DRY - Don't Repeat Yourself**  
  Every piece of knowledge must have a single, unambiguous, authoritative representation within a system.
* **Eliminate Effects Between Unrelated Things**  
  Design components that are self-contained. independent, and have a single, well-defined purpose.
* **There Are No Final Decisions**  
  No decision is cast in stone. Instead, consider each as being written in the sand at the beach, and plan for change.
* **Fix the Problem, Not the Blame**  
  It doesn't really matter whether the bug is your fault or someone else'sâ€”it is still your problem, and it still needs to be fixed.
* **You Can't Write Perfect Software**  
  Software can't be perfect. Protect your code and users from the inevitable errors.
* **Design with Contracts**  
  Use contracts to document and verify that code does no more and no less than it claims to do.
* **Crash Early**  
  A dead program normally does a lot less damage than a crippled one.
* **Use Assertions to Prevent the Impossible**  
  Assertions validate your assumptions. Use them to protect your code from an uncertain world.
* **Use Exceptions for Exceptional Problems**  
  Exceptions can suffer from all the readability and maintainability problems of classic spaghetti code. Reserve exceptions for exceptional things.
* **Minimize Coupling Between Modules**  
  Avoid coupling by writing "shy" code and applying the Law of Demeter.
* **Put Abstractions in Code, Details in Metadata**  
  Program for the general case, and put the specifics outside the compiled code base.
* **Always Design for Concurrency**  
  Allow for concurrency, and you'll design cleaner interfaces with fewer assumptions.
* **Don't Program by Coincidence**  
  Rely only on reliable things. Beware of accidental complexity, and don't confuse a happy coincidence with a purposeful plan.
* **Test Your Estimates**  
  Mathematical analysis of algorithms doesn't tell you everything. Try timing your code in its target environment.
* **Refactor Early, Refactor Often**  
  Just as you might weed and rearrange a garden, rewrite, rework, and re-architect code when it needs it. Fix the root of the problem.
* **Design to Test**  
  Start thinking about testing before you write a line of code.
* **Abstractions Live Longer than Details**  
  Invest in the abstraction, not the implementation. Abstractions can survive the barrage of changes from different implementations and new technologies.
* **Coding Ain't Done 'Til All the Tests Run**  
  'Nuff said.
* **Use Saboteurs to Test Your Testing**  
  Introduce bugs on purpose in a separate copy of the source to verify that testing will catch them.
* **Find Bugs Once**  
  Once a human tester finds a bug, it should be the last time a human tester finds that bug. Automatic tests should check for it from then on.
* **Sign Your Work**  
  Craftsmen of an earlier age were proud to sign their work. You should be, too.

[Back to top](#top)


## [](#avoidTightCoupling)Avoid Tight Coupling

Always choose the loosest possible coupling between entities. In C++ the tightest coupling is Friend, second is Inheritance, then Containment and last is Usage through reference, pointer or handle.

* Friend defines a "must-know" about details of implementation, don't use it unless your happy stating that Xxx really must know about Yyy implementation. and Yyy can never change without informing Xxx.
* Inheritance defines a "is-a" relationship, don't use it unless you really can naturally say Xxx is-a Yyy. Most of the cases containment through interface is what you want.
* Containment defines a "owns-a" relationship, use it when you have a natural Xxx owns-a Yyy relationship.

Most of the time containment through interface and normal usage is what you should go for. Strong ownership always beats sharing through reference counting. Reference counting means "part owns". You would not want to part own anything in real life, so why do that in software? Sooner or later it will leak.

Two key principles to follow:

* **Open Closed Principle**  
  Software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification. That is, such an entity can allow its behaviour to be modified without altering its source code. 
* **Dependency Inversion Principle**  
  High-level modules should not depend on low-level modules. Both should depend on abstractions. Abstractions should not depend upon details. Details should depend upon abstractions. 

[Back to top](#top)

## [](#typeCasting)Type casting

**Never use C-Style Casts**

The C-style cast - "(type) expr" used to convert one fundamental type to another is subject to implementation-defined effects. For scalar types it can result in silent truncation of the value. For pointers and references, it does not check the compatibility of the value with the target type.

* **Don't cast away const, use mutable keyword instead**
* **Don't reinterpret_cast, fix the design instead**
* **Remember that reference cast will throw an error if cast fails**
* **Avoid using pointer or reference casts. They have been referred to as the goto of OO programming, fix the design instead**

Good:
```c++
X* ptr = static_cast( y_ptr ); // ok, compiler checks whether types are compatible
```
Bad:
```c++
(Foo*) ptr; // bad! C-cast is not guaranteed to check and never complains
```

[Back to top](#top)

## [](#classes)Classes

A class interface should be complete and minimal. Class should encapsulate one thing and one thing only. A complete interface allows clients to do anything they may reasonably want to do. On the other hand, a minimal interface will contain as few functions as possible. Class methods must be defined in the same order as they are declared. This helps navigating through code.

### [](#compulsoryMemberFunctions)Compulsory Member Functions

Every class must define default constructor, copy constructor, assignment operator and destructor. If you dont declare them, compiler will and the compiler generated versions are usually not good or safe enough. If your class does not support copying, then declare copy constructor and assignment operator as private and don't define them.

If for example the assignment operator is not needed for a particular class, then it must be declared private and not defined. Any attempt to invoke the operator will result in a compile-time error. On the contrary, if the assignment operator is not declared, then when it is invoked, a compiler-generated form will be created and subsequently executed. This could lead to unexpected results. The same goes with default constructor and copy constructor.

```c++
class X
{
  X();                      // default constructor
  X( const X& );            // copy constructor
  X& operator=( const X& ); // copy assignment operator
  ~X();                     // destructor
};
```

### [](#classTypes)Class Types

Classes can have either **Value** semantics or **Pointer** semantics. Not both. It must be clearly documented whether a class follows value or pointer semantics and this also sets requirements on the class interface.

Classes with **Value** semantics are passed as value types. These classes provide a copy constructor, a default constructor and assignment operator so that they can be copied and also stored in containers.

Classes with **Pointer** semantics are always passed through pointers, references or smart pointers. These classes are ususally compound types that cannot be easily copied and thus prevent copy constructor, and assignment operator. These can be only stored in containers through smart pointers.

### [](#accessRight)Access Rights

Public and protected data should only be used in structs, not classes. Roughly two types of classes exist: those that essentially aggregate data and those that provide an abstraction while maintaining a well-defined state or invariant.

A structure should be used to model an entity that does not require an invariant (Plain Old Data) A class should be used to model an entity that maintains an invariant. **Rationale:** A class is able to maintain its invariant by controlling access to its data. However, a class cannot control access to its members if those members non-private. Hence all data in a class should be private.

### [](#constructors)Constructors

Virtual function calls are not allowed from constructor Rationale: Virtual functions are resolved statically (not dynamically) in constructor

Member initialization order must be the same in which they are declared in the class. Note: Since base class members are initialized before derived class members, base class initializers should appear at the beginning of the member initialization list. **Rationale:** Members of a class are initialized in the order in which they are declared, not the order in which they appear in the initialization list.

Constructor body should not throw an exception, keep constructor simple and trivial. If constructor fails, objects lifecycle never started, destructor will not be called.

Declare all single argument constructors as explicit thus preventing their use as implicit type convertors.

Good:
```c++
class C
{
public:
  explicit C( int );         // good, explicit
  C( int, int );             // ok more than one non-default argument
};
```
Bad:
```c++
class C
{
public:
  C( double );                // bad, can be used in implicit conversion
  C( float f, int i=0 );      // bad, implicit conversion constructor
  C( int i=0, float f=0.0f ); // bad, default constructor, but also a conversion constructor
};
```

### [](#destructors)Destructors

All classes should define a destructor, either:

* public for value types
* public and virtual for base classes with virtual methods
* protected and virtual for base classes to prevent deletion (and ownership) through base class 

This prevents undefined behavior. If an application attempts to delete a derived class object through a base class pointer, the result is undefined if the base class destructor is non-virtual.

Virtual function calls are not allowed from inside the destructor. Rationale: A class's virtual functions are resolved statically (not dynamically) in its destructor

All resources acquired by a class shall be released by the class's destructor.

Destructor is not allowed to throw an exception, avoid doing complicated things in destructor.

### [](#methods)Methods

Don't shortcut, like use the returned reference of getter to assign a new value. If a Setter is missing, add it!
Bad:
```c++
initial.GetPosition() = Position(10, 10); // bad!, If GetPosition is one day changed to return copy
                                          // of Position this code silently changes to a no-op.
```

Good:
```c++
initial.SetPosition( Position( 10, 10 ) );
```

Code that is not used (commented out) should be deleted. Rationale: No dead code should be left to confuse other people. Exception: Code that is simply part of an explanation may appear in comments.

### [](#inlineMemberFunctions)Inline Member Functions

GCC automatically inlines member functions defined within the class body of C++ programs even if they are not explicitly declared inline.
Bad:
```c++
class Color
{
  inline float& GetRed()   { return mRed;   }		// inline keyword not needed
  inline float& GetGreen() { return mGreen; }
};
```
Good:
```c++
class Color
{
  float& GetRed()   { return mRed;   }
  float& GetGreen() { return mGreen; }
};
```

If there are a lot of inlines, they should be in a .inl file. Remember the inline keyword is just a hint to the compiler. Whether a function will be inlined or not is down to the compiler and its flags. 

[Back to top](#top)
