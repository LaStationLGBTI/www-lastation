#####################################################################
#                            Build Stage                            #
#####################################################################
FROM hugomods/hugo:exts AS builder

# Build site
COPY . /src
# Fix theme issue
RUN grep -r --color=none .Site.IsServer /src/themes/hugo-serif-theme/ | sed 's/:.*//' | sort -u | while read f; do sed -i 's/.Site.IsServer/hugo.IsServer/g' $f; done
# Build website
RUN hugo --minify --enableGitInfo

#####################################################################
#                            Final Stage                            #
#####################################################################
FROM hugomods/hugo:nginx
# Copy the generated files to keep the image as small as possible.
COPY --from=builder /src/public /site

