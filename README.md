# hackernews-api-test

# HackerNews API Acceptance Tests

This repository contains acceptance tests for validating the [Hacker News API](https://github.com/HackerNews/API), written in Ruby using MiniTest.

---

## Prerequisites

- [RVM](https://rvm.io/)
- Ruby 3.2.2 (or compatible)
- Bundler

---

## Setup Instructions

### 1. Install Ruby using RVM

```bash
\curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 3.2.2
```

### 2. Set Installed Ruby as Default

```bash
rvm use 3.2.2 --default
```

### 3. Open the project and bundle install

```bash
cd hackernews-api-test
bundle install
```
---

## Setup Instructions

### Run All Tests

```bash
ruby test/run_all_tests.rb
```
### Run a Specific Test File

```bash
ruby test/current_top_story_tests.rb
```