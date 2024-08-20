import { PrismaClient } from '@prisma/client';

const getMockCandidateData = (overrides = {}) => ({ ...overrides });

const prismaMock = {
    candidate: {
        create: jest.fn().mockResolvedValue({}),
        update: jest.fn(),
        delete: jest.fn(),
        findUnique: jest.fn()
    },
    education: {
        create: jest.fn().mockResolvedValue({}),
        update: jest.fn(),
        delete: jest.fn(),
        findUnique: jest.fn()
    },
    workExperience: {
        create: jest.fn().mockResolvedValue({}),
        update: jest.fn(),
        delete: jest.fn(),
        findUnique: jest.fn()
    },
    resume: {
        create: jest.fn().mockResolvedValue({}),
        update: jest.fn(),
        delete: jest.fn(),
        findUnique: jest.fn()
    }
};

jest.mock('@prisma/client', () => ({
    PrismaClient: jest.fn().mockImplementation(() => prismaMock)
}));

export { prismaMock, getMockCandidateData };
