-- fragment-options.lua
-- Exposes Caltech revealjs fragment settings to browser-side helpers.

local function ensure_meta_list(value)
  if value == nil then
    return pandoc.MetaList({})
  end

  if value.t == "MetaList" then
    return value
  end

  return pandoc.MetaList({value})
end

local function source_has_incremental_false()
  if quarto.doc.input_file == nil then
    return false
  end

  local f = io.open(quarto.doc.input_file, "r")
  if f == nil then
    return false
  end

  local in_yaml = false

  for line in f:lines() do
    if line:match("^%s*%-%-%-%s*$") then
      if in_yaml then
        break
      end
      in_yaml = true
    elseif in_yaml and line:match("^%s*incremental:%s*false%s*$") then
      f:close()
      return true
    end
  end

  f:close()
  return false
end

function Pandoc(doc)
  if not source_has_incremental_false() then
    return doc
  end

  local header = ensure_meta_list(doc.meta["header-includes"])

  header:insert(pandoc.MetaBlocks({
    pandoc.RawBlock("html", [[
<script>
window.CaltechRevealjs = window.CaltechRevealjs || {};
window.CaltechRevealjs.incremental = false;
document.documentElement.classList.add("caltech-no-incremental");
</script>
]])
  }))

  doc.meta["header-includes"] = header
  return doc
end
