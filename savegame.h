#ifndef SAVEGAME_H
#define SAVEGAME_H

#include <QObject>
#include <qqml.h>
#include <QString>
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <QDir>

class SaveGame : public QObject
{
    Q_OBJECT
public:
    explicit SaveGame(QObject *parent = nullptr);

    Q_INVOKABLE QString getRawData();
    Q_INVOKABLE void saveData(QString s);
signals:

};

#endif // SAVEGAME_H
