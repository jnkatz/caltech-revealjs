-- logo-inject.lua
-- Injects the Caltech logo at bottom-left of every slide,
-- respecting the .hide_logo class.
-- Embeds the logo as a base64 data URI so the path always resolves.

function Pandoc(doc)
  -- Resolve the logo file relative to this Lua filter's location
  local logo_file = quarto.utils.resolve_path(
    "Caltech_LOGO-Orange_RGB.png"
  )

  -- Read the file and encode as base64
  local f = io.open(logo_file, "rb")
  if f == nil then
    quarto.log.warning(
      "caltech-revealjs: logo file not found at " .. logo_file
    )
    return doc
  end
  local data = f:read("*all")
  f:close()

  local b64 = quarto.base64.encode(data)
  local data_uri = "data:image/png;base64," .. b64

  local css = [[
<style>
.slide-logo {
  position: fixed;
  bottom: 1em;
  left: 3.5em;
  width: 100px;
  height: 24px;
  z-index: 100;
}
.hide_logo .slide-logo {
  display: none !important;
}
</style>
]]

  local logo_html = string.format(
    '<img src="%s" class="slide-logo" alt="Caltech logo" />',
    data_uri
  )

  -- Append to header-includes
  local header = doc.meta['header-includes']
  if header == nil then
    header = pandoc.MetaList({})
  elseif header.t ~= 'MetaList' then
    header = pandoc.MetaList({header})
  end

  header:insert(pandoc.MetaBlocks({
    pandoc.RawBlock('html', css)
  }))
  header:insert(pandoc.MetaBlocks({
    pandoc.RawBlock('html', logo_html)
  }))

  doc.meta['header-includes'] = header
  return doc
end
