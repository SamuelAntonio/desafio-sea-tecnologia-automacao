import random


class CpfLibrary:

    def gerar_cpf_valido(self):
        numeros = [random.randint(0, 9) for _ in range(9)]

        # Primeiro dígito verificador
        soma = sum(
            numero * peso
            for numero, peso in zip(numeros, range(10, 1, -1))
        )

        resto = soma % 11
        primeiro_digito = 0 if resto < 2 else 11 - resto
        numeros.append(primeiro_digito)

        # Segundo dígito verificador
        soma = sum(
            numero * peso
            for numero, peso in zip(numeros, range(11, 1, -1))
        )

        resto = soma % 11
        segundo_digito = 0 if resto < 2 else 11 - resto
        numeros.append(segundo_digito)

        cpf = ''.join(map(str, numeros))

        # Evita sequências repetidas, como 11111111111
        if len(set(cpf)) == 1:
            return self.gerar_cpf_valido()

        return cpf