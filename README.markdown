# Reliance

A Dependency injection container for Objective-C.

## Status

Most stuff sort of works. However, as you can see from the tests, there's a lot of fault injection still to be done.

I'm also not really satisfied with all the class names and method names, so that's likely to change.

Because of this, you can currently consider this software to be of **Alpha** quality.

## How to use?

The best way to get started is to look at the Integration test.

There's no real documentation at the moment, so the tests and the code is pretty much all you have.

## Not quite so frequently asked questions

 * I want to get an NSManagedObjectContext as a service, do I need to create a holder service to get it through?

No. Create a category on NSManagedObjectContext where you define a convenience constructor that takes the dependencies you need to do all the setup, and then use that convenience constructor with Reliance.