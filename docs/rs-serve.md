---
title: rs-serve
date: 10/02/2026_12:17:44
---

```rs
pub async fn serve<B>(bank: B, addr: &str) -> anyhow::Result<()>
where
    B: BankApi + Clone + Send + Sync + 'static,
{
    let state = AppState { bank };

    let app = Router::new()
        .route("/accounts/open", post(open_account::<B>))
        .route("/accounts/show", post(show_account::<B>))
        .route("/accounts/deposit", post(deposit::<B>))
        .with_state(state)
        .layer(TraceLayer::new_for_http());

    let listener = TcpListener::bind(addr).await?;
    axum::serve(listener, app).await?;

    Ok(())
}
```
