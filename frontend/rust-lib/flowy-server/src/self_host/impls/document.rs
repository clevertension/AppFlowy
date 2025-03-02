use anyhow::Error;
use flowy_document_deps::cloud::*;

use lib_infra::future::FutureResult;

pub(crate) struct SelfHostedDocumentCloudServiceImpl();

impl DocumentCloudService for SelfHostedDocumentCloudServiceImpl {
  fn get_document_updates(&self, _document_id: &str) -> FutureResult<Vec<Vec<u8>>, Error> {
    FutureResult::new(async move { Ok(vec![]) })
  }

  fn get_document_latest_snapshot(
    &self,
    _document_id: &str,
  ) -> FutureResult<Option<DocumentSnapshot>, Error> {
    FutureResult::new(async move { Ok(None) })
  }

  fn get_document_data(&self, _document_id: &str) -> FutureResult<Option<DocumentData>, Error> {
    FutureResult::new(async move { Ok(None) })
  }
}
