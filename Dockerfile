# шаг 1
# Базовый образ, содержащий среду выполнения
FROM openjdk:11-slim as build
# Информация о владельце
WORKDIR application
# Файл jar
ARG JAR_FILE=target/*.jar
# Добавить файл в контейнер
COPY ${JAR_FILE} application.jar

# распаковать файл jar
RUN java -Djarmode=layertools -jar application.jar extract
# шаг 2
FROM openjdk:11-slim
# Добавить том, ссылающийся на каталог /tmp
WORKDIR application
# Скопировать распакованное приложение в новый контейнер
COPY --from=build application/dependencies/ ./
COPY --from=build application/spring-boot-loader/ ./
COPY --from=build application/snapshot-dependencies/ ./
COPY --from=build application/application/ ./

# Запустить приложение
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
