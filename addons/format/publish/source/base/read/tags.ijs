NB. tags

NB. =========================================================
NB. structure tags are the main divisions of a report.
NB. note that the <pre> and </pre> tags are also
NB. structure tags, but need special treatment.
StructTags=: readlist''
group
h0
h1
h2
h3
h4
h5
h6
image
list
para
newpage/
plot
skip
table
toc
)

NB. tags not supported in groups:
NotGroupTags=: <;._1 ' h0 h1 newpage/ toc'