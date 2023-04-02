json.set! :data do
  json.array! @documents do |document|
    json.partial! 'documents/document', document: document
    json.url  "
              #{link_to 'Show', document }
              #{link_to 'Edit', edit_document_path(document)}
              #{link_to 'Destroy', document, method: :delete, data: { confirm: 'Are you sure?' }}
              "
  end
end