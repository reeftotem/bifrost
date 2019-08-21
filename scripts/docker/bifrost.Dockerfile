FROM debian:stretch-slim

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL com.liebi.image.authors="lark930@gmail.com" \
	com.liebi.image.vendor="Liebi Technologies" \
	com.liebi.image.title="Liebi/bifrost" \
	com.liebi.image.description="Bifrost: A parachain focused on building bridges of chains which based on PoS consensus." \
	com.liebi.image.source="https://github.com/bifrost-codes/bifrost/blob/${VCS_REF}/scripts/docker/bifrost.Dockerfile" \
	com.liebi.image.revision="${VCS_REF}" \
	com.liebi.image.created="${BUILD_DATE}" \
	com.liebi.image.documentation="https://github.com/bifrost-codes/bifrost"

# show backtraces
ENV RUST_BACKTRACE 1

# install tools and dependencies
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y \
		libssl1.1 \
		ca-certificates \
		curl && \
# apt cleanup
	apt-get autoremove -y && \
	apt-get clean && \
	find /var/lib/apt/lists/ -type f -not -name lock -delete; \
# add user
	useradd -m -u 1000 -U -s /bin/sh -d /bifrost bifrost

# add bifrost binary to docker image
COPY ./bifrost /usr/local/bin

USER bifrost

# check if executable works in this container
RUN /usr/local/bin/bifrost --version

EXPOSE 30333 9933 9944
VOLUME ["/bifrost"]

ENTRYPOINT ["/usr/local/bin/bifrost"]

