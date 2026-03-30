function Pandoc(doc)
  -- Intentionally a no-op. Quarto executes knitr before the
  -- Pandoc/Lua filter stage, so executable helper setup must be
  -- sourced explicitly from R contexts that need it.
  return doc
end
