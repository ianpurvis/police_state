[![Build Status](https://travis-ci.com/ianpurvis/police_state.svg?branch=trunk)](https://travis-ci.com/ianpurvis/police_state)
[![codecov](https://codecov.io/gh/ianpurvis/police_state/branch/trunk/graph/badge.svg)](https://codecov.io/gh/ianpurvis/police_state)
[![Doc Status](http://inch-ci.org/github/ianpurvis/police_state.svg?branch=trunk)](http://inch-ci.org/github/ianpurvis/police_state)

# Police State
Lightweight state machine for Active Record and Active Model.


## Background
After experimenting with state machines in a recent project, I became interested in a workflow that felt more natural for rails. In particular, I wanted to reduce architectural overlap incurred by flow control, guard, and callback workflows.

The goal of Police State is to let you easily work with state machines based on `ActiveModel::Dirty`, `ActiveModel::Validation`, and `ActiveModel::Callbacks`


## Usage
Police State revolves around the use of `TransitionValidator` and two helper methods, `attribute_transitioning?` and `attribute_transitioned?`.

To get started, just include `PoliceState` in your model and define a set of valid transitions:

```ruby
class Model < ApplicationRecord
  include PoliceState

  enum status: {
    queued: 0,
    active: 1,
    complete: 2,
    failed: 3
  }
  
  validates :status, transition: { from: nil, to: :queued }
  validates :status, transition: { from: :queued, to: :active }
  validates :status, transition: { from: :active, to: :complete }
  validates :status, transition: { from: [:queued, :active], to: :failed }
end
```

### Committing a Transition
One aspect of Police State that will feel different than other ruby state machines is the idea that in-memory state has not fully transitioned until it is persisted to the database. This lets you operate within a traditional Active Record workflow:

```ruby
model = Model.new(status: :complete)
# => #<Model:0x007fa94844d088 @status=:complete>

model.status_transitioning?(from: nil)
# => true

model.status_transitioning?(to: :complete)
# => true

model.valid?
# => false

model.errors.to_hash
# => {:status=>["can't transition to complete"]}

model.save
# => false

model.save!
# => ActiveRecord::RecordInvalid: Validation failed: Status can't transition to complete

model.status = :queued
# => :queued

model.valid?
# => true

model.save
# => true

model.status_transitioned?(from: nil, to: :queued)
# => true

```


### Guard Conditions
Guard conditions can be introduced for a state by adding a conditional ActiveRecord validation:

```ruby
validates :another_field, :presence, if: -> { queued? }
```

### Callbacks

Callbacks can be attached to specific transitions by adding a condition on `attribute_transitioned?`. If the callback needs to occur before persistence, `attribute_transitioning?` can also be used.

```ruby
after_commit :notify, if: -> { status_transitioned?(to: :complete) }
after_commit :alert, if: -> { status_transitioned?(from: :active, to: :failed) }
after_commit :log, if: -> { status_transitioned? }
```

### Events
Explicit event languge can be added to models by wrapping `update` and / or `update!`

```ruby
def run
  update(status: :active) 
end
  
def run!
  update!(status: :active)
end
```

The bang methods defined by `ActiveRecord::Enum` work as well:

```ruby
model.active!
# => ActiveRecord::RecordInvalid: Validation failed: Status can't transition to active
```

### Validation Logic
One important note about `TransitionValidator` is that it performs a unidirectional validation. For example, the following ensures that the `active` state can only be reached from the `queued` state:

```ruby
validates :status, transition: { from: :queued, to: :active }
```

However, this does not prevent `queued` from transitioning to other states. Those states must be controlled by their own validators.


### Active Model
If you are using Active Model, make sure your class correctly implements `ActiveModel::Dirty`. For an example, check out [spec/test_model.rb](spec/test_model.rb)


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'police_state'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install police_state
```


## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[![https://purvisresearch.com](logo.svg)](https://purvisresearch.com)
