# Best Practices with Docker

- Use official images whenever available.
- Always use fixed version tags where possible. These provide predictable builds and avoid unexpected breaking changes from `latest`.
- Use official images based on lightweight distributions (e.g., Alpine) where appropriate. Avoid full OS distribution images (e.g., Ubuntu, CentOS) when they aren't necessary, as they are larger, include libraries and utilities the application may not need, and increase the attack surface.
- Optimise Docker image layer caching by ordering Dockerfile commands from the least frequently changing to the most frequently changing.
- Use `.dockerignore` to explicitly exclude unnecessary and sensitive files and folders, reducing the image size.
- Make use of multi-stage builds to prevent unnecessary build artifacts from bloating the final image (e.g., `package.json`, `pom.xml`, JVM, Maven, Gradle).

  - **Build stage:** `AS build`
  - **Run stage:** `--from=build`
  - The final image is built only from the final **run stage**.
- Create a dedicated user and group with the least privileges required to run the container. Avoid running containers as `root`.
- Scan images for vulnerabilities using `docker scout cves <image>`. You need to be logged in to Docker Hub. You can log in via the command line using `docker login`.