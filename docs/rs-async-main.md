---
title: rs-async-main
date: 10/02/2026_12:16:54
---

```rs
mod adapters;
mod core;
use crate::{
    adapters::{
        event_sinks::FileEventSink, http::server, inmem_repo::InMemoryAccountRepo, observability,
    },
    core::usecase::BankService,
};

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    observability::init_tracing();

    let repo = InMemoryAccountRepo::new();
    let events = FileEventSink::new("events.log");
    let bank = BankService::new(repo, events);

    server::serve(bank, "127.0.0.1:3000").await?;
    Ok(())
}
```
