#include "savegame.h"

SaveGame::SaveGame(QObject *parent) : QObject(parent)
{
}

QString SaveGame::getRawData()
{
    QFile file("board.json");
    file.open(QIODevice::ReadWrite | QIODevice::Text);
    QTextStream in(&file);
    QString s=in.readAll();
    file.close();
    return s;
}

void SaveGame::saveData(QString s)
{
    QFile file("board.json");
    file.open(QIODevice::WriteOnly | QIODevice::Text);
    file.resize(0);
    QTextStream out(&file);
    out << s;
    file.close();
}
