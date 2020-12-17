#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <savegame.h>
#include <QFont>
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    QQuickStyle::setStyle("Material");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    int id = QFontDatabase::addApplicationFont(":/font/neuropol.ttf");
    QString family = QFontDatabase::applicationFontFamilies(id).at(0);
    QFont gameFont(family);

    app.setFont(gameFont);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.globalObject().setProperty("saveGame",engine.newQObject(new SaveGame));
    engine.load(url);
    return app.exec();
}
