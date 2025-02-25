# CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- Added: methods to handle events are underscored when String#underscore is
  defined, e.g. `def MyEvent` versus `def my_event`.
- Added: Publisher#unsubscribe method
- Added: Publisher#unsubscribe_all method

## [0.1.0]

- Added: Ability for an object to publish events
- Added: Ability for an object to map from events to methods
- Added: An Event object for creating global pub/sub
